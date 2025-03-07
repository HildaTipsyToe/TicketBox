import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketbox/domain/entities/post.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';

/// Abstract class that represent the Post reposistory
///
/// This interface defines the contract for Post-related data operations.
abstract class IPostRepository {
  Future<List<Post>> getPostsByGroupId(String groupId);
  Future<List<Post>> getPostsByReceiverIdAndGroupId(
      String receiverId, String groupId);
  Stream<List<Post>> getPostsByReceiverIdAndGroupIdStream(
      String receiverId, String groupId);
  Future<void> addPost(Post post);
  Future<void> updatePost(String id, Map<String, dynamic> newData);
  Future<void> deletePost(Post post);
}

/// Class that represent the post repoistory
///
/// The [PostRepositoryImpl] have methods for:
/// - create posts
/// - retriving posts by group id
/// - retriving posts by reciver id and group id
/// - updating posts
/// - deleting posts
class PostRepositoryImpl extends IPostRepository {
  final ApiDataSource _apiDataSource;

  PostRepositoryImpl(this._apiDataSource);

  /// Method for giving a user a posts [post]
  @override
  Future<void> addPost(Post post) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      // Reference to the new post
      DocumentReference postRef = _apiDataSource.postCollection.doc();

      // Add the post to Firestore
      batch.set(postRef, post.toJson());

      // Query for the membership related to the group and receiver
      QuerySnapshot membershipSnapshot = await _apiDataSource
          .membershipCollection
          .where('groupId', isEqualTo: post.groupId)
          .where('userId', isEqualTo: post.receiverId)
          .get();

      // Going through the membershipSnapshot to update the balance
      for (QueryDocumentSnapshot doc in membershipSnapshot.docs) {
        final membershipData = doc.data() as Map<String, dynamic>;
        final currentBalance = membershipData['balance'] as int;

        final newBalance = currentBalance - post.price;

        // Update membership balance
        batch.update(doc.reference, {'balance': newBalance});
      }
      // Commit the batch operation
      await batch.commit();
    } catch (error) {
      log('Error handeling adding a post: $error');
      Future.error('Error handeling adding a post: $error');
    }
  }

  /// Method for deleting post from a membership with [post] as a parameter
  @override
  Future<void> deletePost(Post post) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      final price = post.price;
      final receiverId = post.receiverId;
      final groupId = post.groupId;

      DocumentReference postRef =
          _apiDataSource.postCollection.doc(post.postId);

      batch.delete(postRef);

      QuerySnapshot membershipSnapshot = await _apiDataSource
          .membershipCollection
          .where('groupId', isEqualTo: groupId)
          .where('userId', isEqualTo: receiverId)
          .get();

      for (QueryDocumentSnapshot doc in membershipSnapshot.docs) {
        final membershipData = doc.data() as Map<String, dynamic>;
        final currentBalance = membershipData['balance'] as int;

        final newBalance = currentBalance + price;

        batch.update(doc.reference, {'balance': newBalance});
      }

      await batch.commit();
    } catch (error) {
      log('Error handeling deleting post: $error');
      return Future.error('Error handeling deleting post: $error');
    }
  }

  /// Method for fetching a post with [groupId] as a parameter
  @override
  Future<List<Post>> getPostsByGroupId(String groupId) async {
    try {
      QuerySnapshot querySnapshot = await _apiDataSource.postCollection
          .where('groupId', isEqualTo: groupId)
          .get();

      List<Post> posts = querySnapshot.docs
          .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>)
              .copyWith(postId: doc.id))
          .toList();

      return posts;
    } catch (error) {
      log('Error handeling retivering post by group id: $error');
      return Future.error(
          'Error handeling retivering post by group id: $error');
    }
  }

  /// Method for fetching a post with [groupId] and [receiverId] as parameters
  @override
  Future<List<Post>> getPostsByReceiverIdAndGroupId(
      String receiverId, String groupId) async {
    try {
      QuerySnapshot querySnapshot = await _apiDataSource.postCollection
          .where('userId', isEqualTo: receiverId)
          .where('groupId', isEqualTo: groupId)
          .get();

      List<Post> posts = querySnapshot.docs
          .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>)
              .copyWith(postId: doc.id))
          .toList();

      return posts;
    } catch (error) {
      log('Error handeling retreving posts by receiver and group id');
      return Future.error(
          'Error handeling retreving posts by receiver and group id');
    }
  }

  /// Method for updating post with [id] and [newData] as parameters
  @override
  Future<void> updatePost(String id, Map<String, dynamic> newData) async {
    try {
      return await _apiDataSource.postCollection.doc(id).update(newData);
    } catch (error) {
      log('Error handeling updating the post: $error');
      return Future.error('Error handeling updating the post: $error');
    }
  }

  @override
  Stream<List<Post>> getPostsByReceiverIdAndGroupIdStream(
      String receiverId, String groupId) {
    var temp = _apiDataSource.postCollection
        .where('receiverId', isEqualTo: receiverId)
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>)
                .copyWith(postId: doc.id))
            .toList());
    return temp;
  }
}

class PostRepositoryMock extends IPostRepository {
  @override
  Future<void> addPost(Post post) async {
    print('Mock - Post added');
  }

  @override
  Future<void> deletePost(Post post) async {
    print('Mock - Post deleted');
  }

  @override
  Future<List<Post>> getPostsByGroupId(String groupId) async {
    print('Mock - Get post by GroupId');
    List<Post> p = [
      Post(
          adminId: 'adminId',
          adminName: 'adminName',
          groupId: groupId,
          price: 1,
          receiverId: 'receiverId',
          receiverName: 'receiverName',
          ticketTypeId: 'ticketTypeId',
          ticketTypeName: 'ticketTypeName')
    ];
    return p;
  }

  @override
  Future<List<Post>> getPostsByReceiverIdAndGroupId(
      String receiverId, String groupId) async {
    print('Mock - Get post by ReceiverId and GroupId');
    List<Post> p = [
      Post(
          adminId: 'adminId',
          adminName: 'adminName',
          groupId: groupId,
          price: 1,
          receiverId: 'receiverId',
          receiverName: 'receiverName',
          ticketTypeId: 'ticketTypeId',
          ticketTypeName: 'ticketTypeName')
    ];
    return p;
  }

  @override
  Future<void> updatePost(String id, Map<String, dynamic> newData) async {
    print('Mock - Post updated');
  }

  @override
  Stream<List<Post>> getPostsByReceiverIdAndGroupIdStream(
      String receiverId, String groupId) {
    // TODO: implement getPostsByReceiverIdAndGroupIdStream
    throw UnimplementedError();
  }
}
