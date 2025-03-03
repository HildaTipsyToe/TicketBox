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
/// The [MembershipRepository] have methods for:
/// - create membership
/// - retriving membership by user ID
/// - retriving membership by group ID
/// - update membership
/// - deleting membership
/// - authorization to update membership
/// - authorization to delete membership
class MembershipRepository extends IMembershipRepository {
  final ApiDataSource _apiDataSource;

  MembershipRepository(this._apiDataSource);

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

  /// Method for deleting membership with value [membership]
  @override
  Future<void> deleteMembership(Membership membership) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      // Query and delete posts related to the memberships
      // ....

      // Deleting the group itself
      DocumentReference membershipRef =
          _apiDataSource.membershipCollection.doc(membership.membershipId);
      batch.delete(membershipRef);

      await batch.commit();
    } catch (error) {
      log('Error handeling the deletion of a memebership: $error');
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
          .map((doc) => Membership.fromMap(doc.data() as Map<String, dynamic>))
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
          .map((doc) => Membership.fromMap(doc.data() as Map<String, dynamic>))
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
