import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticketbox/domain/entities/membership.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';
import 'package:ticketbox/infrastructure/datasource/auth_datasource.dart';

/// Abstract class that represent the group reposistory
///
/// This interface defines the contract for memberships-related data operations.

abstract class IGroupRepository {
  Future<String> addGroup(Map<String, dynamic> groupData);
  Future<void> updateGroup(String id, Map<String, dynamic> newData);
  Future<void> deleteGroup(String groupId);
}

/// Class that represent the group repository
///
/// The [GroupRepositoryImpl] have methods for:
/// - create group
/// - update group
/// - deleting group
class GroupRepositoryImpl extends IGroupRepository {
  final ApiDataSource _apiDataSource;
  final AuthDataSource _authDataSource;

  GroupRepositoryImpl(this._apiDataSource, this._authDataSource);

  /// Method for creating a group with a property of [Map] named [groupData]
  @override
  Future<String> addGroup(Map<String, dynamic> groupData) async {
    User? currentUser = await _authDataSource.getCurrentUser();
    if (currentUser == null) {
      return "Unable to find current user!";
    }
    try {
      DocumentReference groupRef =
          await _apiDataSource.groupCollection.add(groupData);

      String groupId = groupRef.id;

      Membership membership = Membership(
        userId: currentUser.uid,
        userName: currentUser.displayName!,
        groupId: groupId,
        groupName: groupData['groupName'],
        balance: 0,
        roleId: 1,
      );

      await _apiDataSource.membershipCollection.add(membership.toJson());
      return "Group created!";
    } catch (error) {
      log('Error handeling adding group: $error');
      return Future.error('Error handeling adding group: $error');
    }
  }

  /// Method for deleting a group with a property of [String] named [groupId]
  @override
  Future<void> deleteGroup(String groupId) async {
    try {
      QuerySnapshot membershipSnapshot = await _apiDataSource
          .membershipCollection
          .where('groupId', isEqualTo: groupId)
          .get();

      for (QueryDocumentSnapshot doc in membershipSnapshot.docs) {
        await doc.reference.delete(); // Slet hvert medlemskab
      }

      QuerySnapshot postsSnapshot = await _apiDataSource.postCollection
          .where('groupId', isEqualTo: groupId)
          .get();

      for (QueryDocumentSnapshot doc in postsSnapshot.docs) {
        await doc.reference.delete();
      }

      QuerySnapshot messagesSnapshot = await _apiDataSource.messageCollection
          .where('groupId', isEqualTo: groupId)
          .get();

      for (QueryDocumentSnapshot doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      DocumentReference groupRef = _apiDataSource.groupCollection.doc(groupId);
      await groupRef.delete();

    } catch (error) {
      log('Error handling deletion of group: $error');
      return Future.error('Error handling deletion of group: $error');
    }
  }

  /// Method for updating a group with a property of [Map] named [newData]
  @override
  Future<void> updateGroup(String id, Map<String, dynamic> newData) async {
    try {
      return _apiDataSource.groupCollection.doc(id).update(newData);
    } catch (error) {
      log('Error handling updating the group: $error');
      return Future.error('Error handling updating the group: $error');
    }
  }
}

class GroupRepositoryMock extends IGroupRepository {
  @override
  Future<String> addGroup(Map<String, dynamic> groupData) async {
    print('Mock - add group');
    return 'Group created';
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    print('Mock - Group deleted');
  }

  @override
  Future<void> updateGroup(String id, Map<String, dynamic> newData) async {
    print('Mock - Group updated');
  }
}
