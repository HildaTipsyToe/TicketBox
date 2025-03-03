// Abstract repository interface for Post
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketbox/domain/entities/message.dart';

import '../datasource/api_datasource.dart';

/// Abstract class that represent the message reposistory
///
/// This interface defines the contract for message-related data operations.
abstract class IMessageRepository {
  // Future<List<Message>> getMessagesByGroupId(String groupId);
  Stream<QuerySnapshot> getMessageStream(String groupId);
  Future<void> addMessage(Message message);
  Future<void> deleteMessage(String messageId);
}

// Mockup implementation of the Post repository
class MessageRepositoryMock implements IMessageRepository {
  @override
  Future<void> addMessage(Message message) async {
    // TODO: implement addMessage
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    // TODO: implement deleteMessage
  }

  @override
  Stream<QuerySnapshot<Object?>> getMessageStream(String groupId) {
    // TODO: implement getMessageStream
    throw UnimplementedError();
  }
}

// Concrete implementation of the Post repository
class MessageRepositoryImpl implements IMessageRepository {
  final ApiDataSource _apiDataSource;

  MessageRepositoryImpl(this._apiDataSource);

  /// Returns a real-time stream of messages for a specific group by [groupId].
  ///
  /// This function listens to the Firestore collection and fetches messages
  /// where the `groupId` matches the given parameter.
  /// Messages are ordered by `timeStamp` in descending order (newest first).
  @override
  Stream<QuerySnapshot> getMessageStream(String groupId) {
    return _apiDataSource.messageCollection
        .where('groupId', isEqualTo: groupId)
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  /// Adds a new message by [message] to the Firestore database using a batch operation.
  @override
  Future<void> addMessage(Message message) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      // Reference to the new message
      DocumentReference messageRef = _apiDataSource.messageCollection.doc();

      // Add the message to Firestore
      batch.set(messageRef, message.toJson());

      // Commit the batch operation
      await batch.commit();
    } catch (e) {
      print('Error adding post and updating memberships: $e');
    }
  }

  /// Deletes a message by [messageId] in the Firestore database using a batch operation.
  @override
  Future<void> deleteMessage(String messageId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      // Reference to the message to be deleted
      DocumentReference messageRef = _apiDataSource.messageCollection.doc(messageId);

      // Delete the message
      batch.delete(messageRef);

      // Commit the batch operation
      await batch.commit();
    } catch (e) {
      print('Error deleting post and updating memberships: $e');
    }
  }
}
