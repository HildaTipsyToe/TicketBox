// Abstract repository interface for Post
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketbox/domain/entities/messages.dart';

abstract class IMessageRepository {
  Future<List<Message>> getMessagesByGroupId(String groupId);
  Future<void> addMessage(Message message);
  Future<void> deleteMessage(Message post);
}

// Concrete implementation of the Post repository
class MessageRepositoryImpl implements IMessageRepository {
  final ApiDataSource _apiDataSource;

  MessageRepositoryImpl(this._apiDataSource);

  @override
  Future<List<Message>> getMessagesByGroupId(String groupId) async {
    // Query the posts collection where the specified field matches the provided value
    QuerySnapshot querySnapshot = await _apiDataSource.postCollection
        .where('groupId', isEqualTo: groupId)
        .get();

    // Map the documents to the Post model
    List<Post> posts = querySnapshot.docs
        .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>)
        .copyWith(postId: doc.id))
        .toList();

    return posts;
  }

  @override
  Future<void> addMessage(Message message) async {
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

      for (QueryDocumentSnapshot doc in membershipSnapshot.docs) {
        final membershipData = doc.data() as Map<String, dynamic>;
        final currentBalance = membershipData['balance'] as int;

        // Calculate new balance
        final newBalance = currentBalance - post.price;

        // Update membership balance
        batch.update(doc.reference, {'balance': newBalance});
      }

      // Commit the batch operation
      await batch.commit();
    } catch (e) {
      print('Error adding post and updating memberships: $e');
    }
  }

  @override
  Future<void> deleteMessage(Message post) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      // Extract post data
      final price = post.price;
      final groupId = post.groupId;
      final receiverId = post.receiverId;

      // Reference to the post to be deleted
      DocumentReference postRef =
      _apiDataSource.postCollection.doc(post.postId);

      // Delete the post
      batch.delete(postRef);

      // Query for the membership related to the group and receiver
      QuerySnapshot membershipSnapshot = await _apiDataSource
          .membershipCollection
          .where('groupId', isEqualTo: groupId)
          .where('userId', isEqualTo: receiverId)
          .get();

      for (QueryDocumentSnapshot doc in membershipSnapshot.docs) {
        final membershipData = doc.data() as Map<String, dynamic>;
        final currentBalance = membershipData['balance'] as int;

        // Calculate new balance
        final newBalance = currentBalance + price;

        // Update membership balance
        batch.update(doc.reference, {'balance': newBalance});
      }

      // Commit the batch operation
      await batch.commit();
    } catch (e) {
      print('Error deleting post and updating memberships: $e');
    }
  }
}
