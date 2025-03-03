import 'dart:developer';
import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/domain/entities/membership.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';
import 'package:ticketbox/infrastructure/datasource/auth_datasource.dart';
import 'package:ticketbox/infrastructure/repository/membership_repository.dart';

abstract class IGroupReposistory {
  Future<String> addGroup(Map<String, dynamic> groupData);
  Future<void> updateGroup(String id, Map<String, dynamic> newData);
  Future<void> deleteGroup(String groupId);
}

/// Class that represent the group repository
///
/// The [GroupRepository] have methods for:
/// - create group
/// - update group
/// - deleting group
class GroupRepository extends IGroupReposistory {
  final ApiDataSource _apiDataSource;

  GroupRepository(this._apiDataSource);

  @override
  Future<String> addGroup(Map<String, dynamic> groupData) async {
    User? currentUser = await sl<AuthDataSource>().getCurrentUser();
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

  @override
  Future<void> deleteGroup(String groupId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      QuerySnapshot membershipSnapshot = await _apiDataSource
          .membershipCollection
          .where('groupId', isEqualTo: groupId)
          .get();

      for (QueryDocumentSnapshot docs in membershipSnapshot.docs) {
        batch.delete(docs.reference);
      }

      QuerySnapshot postsSnapshot = await _apiDataSource.postCollection
          .where('groupId', isEqualTo: groupId)
          .get();

      for (QueryDocumentSnapshot docs in postsSnapshot.docs) {
        batch.delete(docs.reference);
      }

      QuerySnapshot messagesSnapshot = await _apiDataSource.messageCollection
          .where('groupId', isEqualTo: groupId)
          .get();

      for (QueryDocumentSnapshot docs in messagesSnapshot.docs){
        batch.delete(docs.reference);
      }

      DocumentReference groupRef = _apiDataSource.groupCollection.doc(groupId);
      batch.delete(groupRef);

      await batch.commit();
    } catch (error) {
      log('Error handeling deletion of group: $error');
      return Future.error('Error handeling deletion of group: $error');
    }
  }

  @override
  Future<void> updateGroup(String id, Map<String, dynamic> newData) async {
    // TODO: implement updateGroup
    throw UnimplementedError();
  }
}
