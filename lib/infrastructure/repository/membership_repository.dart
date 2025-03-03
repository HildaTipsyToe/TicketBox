import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/domain/entities/membership.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';
import 'package:ticketbox/infrastructure/repository/auth_repository.dart';

/// Abstract class that represent the membership reposistory
///
/// This interface defines the contract for memberships-related data operations.
abstract class IMembershipRepository {
  Future<List<Membership>> getMembershipsByGroupId(String id);
  Future<List<Membership>> getMembershipByUserID(String id);
  Future<void> addMembership(Membership membershipData);
  Future<void> updateMembership(String id, Map<String, dynamic> newData);
  Future<void> deleteMembership(Membership membership);
  Future<Map<String, dynamic>> canDeleteMembership(Membership membership);
  Future<bool> canUpdateMembershipRole(Membership membership);
}

/// Class that represent the membership repository
///
/// The [MembershipRepositoryImpl] have methods for:
/// - create membership
/// - retriving membership by user ID
/// - retriving membership by group ID
/// - update membership
/// - deleting membership
/// - authorization to update membership
/// - authorization to delete membership
class MembershipRepositoryImpl extends IMembershipRepository {
  final ApiDataSource _apiDataSource;

  MembershipRepositoryImpl(this._apiDataSource);

  /// Method for giving a user a membership to a group with value [membershipData]
  @override
  Future<void> addMembership(Membership membershipData) async {
    final groupId = membershipData.groupId;
    final userId = membershipData.userId;
    try {
      QuerySnapshot membershipSnapshot = await _apiDataSource
          .membershipCollection
          .where('groupId', isEqualTo: groupId)
          .where('userId', isEqualTo: userId)
          .get();

      if (membershipSnapshot.docs.isEmpty) {
        await _apiDataSource.membershipCollection.add(membershipData.toJson());
      }
    } catch (error) {
      log('Error handeling adding membership: $error');
      return;
    }
  }

  /// Method for authorizing user can delete a memebership with value [membership]
  ///
  /// Ensures the user cant delete himself if there is no other admin in the group
  /// and if the group is only 1 member its being deleted.
  @override
  Future<Map<String, dynamic>> canDeleteMembership(
      Membership membership) async {
    Map<String, dynamic> result = {
      'canDelete': false,
      'message': '',
      'groupDeleted': false
    };
    User? user = await sl<IAuthRepository>().getCurrentUser();
    List<Membership> groupMemberships =
        await getMembershipsByGroupId(membership.groupId);

    if (groupMemberships.length == 1) {
      result['canDelete'] = true;
      result['message'] =
          'Gruppen er blevet slettet, da det sidste medlem er blevet fjernet.';
      result['groupDeleted'] = true;
    }

    bool otherAdminsExist =
        groupMemberships.any((x) => x.roleId == 1 && x.userId != user?.uid);

    if (!otherAdminsExist && membership.userId == user?.uid) {
      result['canDelete'] =
          false; //should already be false, but hey! can be to sure sometimes
      result['mesage'] =
          'Du kan ikke forlade gruppen som den eneste administrator.';
    } else {
      result['canDelete'] = true;
      result['message'] = 'Bruger er blevet fjernet fra gruppen';
    }
    return result;
  }

  /// Method for deleting membership and members posts with value [membership]
  @override
  Future<void> deleteMembership(Membership membership) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      // Query and delete posts related to the memberships
      // ....
      QuerySnapshot postsSnapshot = await _apiDataSource.postCollection
          .where('userId', isEqualTo: membership.userId)
          .get();

      for (QueryDocumentSnapshot docs in postsSnapshot.docs) {
        batch.delete(docs.reference);
      }

      // Deleting the group itself
      DocumentReference membershipRef =
          _apiDataSource.membershipCollection.doc(membership.membershipId);
      batch.delete(membershipRef);

      await batch.commit();
    } catch (error) {
      log('Error handeling the deletion of a memebership: $error');
      return Future.error(
          'Error handeling the deletion of a memebership: $error');
    }
  }

  /// Method for authorizing user can update a memebership with value [membership]
  ///
  /// Ensures the user cant changes his own role, if he is the only admin in the group
  @override
  Future<bool> canUpdateMembershipRole(Membership membership) async {
    User? user = await sl<IAuthRepository>().getCurrentUser();
    List<Membership> groupMemberships =
        await getMembershipsByGroupId(membership.groupId);

    bool otherAdminsExist =
        groupMemberships.any((x) => x.roleId == 1 && x.userId != user?.uid);

    if (!otherAdminsExist && membership.userId == user?.uid) {
      return false;
    } else {
      return true;
    }
  }

  /// Method for retriving memberships by the user ID with value [id]
  @override
  Future<List<Membership>> getMembershipByUserID(String id) async {
    try {
      var querySnapshot = await _apiDataSource.membershipCollection
          .where('userId', isEqualTo: id)
          .get();

      List<Membership> membership = querySnapshot.docs
          .map((doc) => Membership.fromMap(doc.data() as Map<String, dynamic>)
              .copyWith(membershipId: doc.id)) //using the CopyWith because the Id is the doc id, and not in the object itself.
          .toList();

      return membership;
    } catch (error) {
      log('Error handeling fetching membership by user Id: $error');
      return Future.error('Error fetching the memebership by user id: $error');
    }
  }

  /// Method for retriving memebership by the group ID with value [id]
  @override
  Future<List<Membership>> getMembershipsByGroupId(String id) async {
    try {
      var querySnapshot = await _apiDataSource.membershipCollection
          .where('groupId', isEqualTo: id)
          .get();

      List<Membership> membership = querySnapshot.docs
          .map((doc) => Membership.fromMap(doc.data() as Map<String, dynamic>)
              .copyWith(membershipId: doc.id))
          .toList();

      return membership;
    } catch (error) {
      log('Error handeling fetching the membershipsByGroupId: $error');
      return Future.error('Error fething the membership: $error');
    }
  }

  /// Method for updating the memebership with values [id] and [newData]
  @override
  Future<void> updateMembership(String id, Map<String, dynamic> newData) {
    try {
      return _apiDataSource.membershipCollection.doc(id).update(newData);
    } catch (error) {
      log('Error handeling updating the memebership of a user: $error');
      return Future.error('Error updating the membership: $error');
    }
  }
}

class MembershipRepositoryMock extends IMembershipRepository {
  @override
  Future<void> addMembership(Membership membershipData) async {
    print('Mock - Membership created');
  }

  @override
  Future<Map<String, dynamic>> canDeleteMembership(Membership membership) async {
    print('Mock - can delete?');
    Map<String, dynamic> result = {
      'canDelete': false,
      'message': '',
      'groupDeleted': false
    };
    return result;
  }

  @override
  Future<bool> canUpdateMembershipRole(Membership membership) async {
    print('Mock - can update?');
    return true;
  }

  @override
  Future<void> deleteMembership(Membership membership) async {
    print('Mock - Membership deleted');
  }

  @override
  Future<List<Membership>> getMembershipByUserID(String id) async {
    print('Mock - Get membership by userId');
    List<Membership> m = [
      Membership(userId: 'userId', userName: 'userName', groupId: 'groupId1', groupName: 'groupName1', balance: 1, roleId: 1),
      Membership(userId: 'userId', userName: 'userName', groupId: 'groupId2', groupName: 'groupName2', balance: 2, roleId: 2)
    ];
    return m;
  }

  @override
  Future<List<Membership>> getMembershipsByGroupId(String id) async {
    print('Mock - Get membership by groupId');
    List<Membership> m = [
      Membership(userId: 'userId1', userName: 'userName1', groupId: 'groupId', groupName: 'groupName', balance: 1, roleId: 1),
      Membership(userId: 'userId2', userName: 'userName2', groupId: 'groupId', groupName: 'groupName', balance: 2, roleId: 2)
    ];
    return m;
  }

  @override
  Future<void> updateMembership(String id, Map<String, dynamic> newData) async {
    print('Mock - membership updated');
  }
}
