// Abstract repository interface for Post
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketbox/domain/entities/message.dart';

import '../datasource/api_datasource.dart';

/// Class that represent the message repository
///
/// The [MessageRepository] have methods for:
/// - Stream messages by [groupId]
/// - Add message
/// - delete message by [messageId]
abstract class IMessageRepository {
  Stream<List<Message>> getMessageStream(String groupId);
  Future<void> addMessage(Message message);
  Future<void> updatePostUserName(String userId, String newName);
  Future<void> deleteMessage(String messageId);
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
  Stream<List<Message>> getMessageStream(String groupId) {
    return _apiDataSource.messageCollection
        .where('groupId', isEqualTo: groupId)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Message.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  /// Adds a new message by [message] to the Firestore database using a batch operation.
  @override
  Future<void> addMessage(Message message) async {
    try {
      DocumentReference messageRef = _apiDataSource.messageCollection.doc();
      await messageRef.set(message.toJson());
    } catch (e) {
      print('Error adding post and updating memberships: $e');
    }
  }

  /// Deletes a message by [messageId] in the Firestore database using a batch operation.
  @override
  Future<void> deleteMessage(String messageId) async {
    try {
      DocumentReference messageRef =
          _apiDataSource.messageCollection.doc(messageId);
      await messageRef.delete();
    } catch (e) {
      print('Error deleting post and updating memberships: $e');
    }
  }

  @override
  Future<void> updatePostUserName(String userId, String newName) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      QuerySnapshot messageSnapshot = await _apiDataSource.messageCollection
          .where('userId', isEqualTo: userId)
          .get();

      for (QueryDocumentSnapshot docs in messageSnapshot.docs) {
        Map<String, dynamic> data = docs.data() as Map<String, dynamic>;
        Message updatedMessage = Message(
          userId: userId,
          userName: newName,
          groupId: data['groupId'],
          text: data['text'],
          timeStamp: data['timeStamp'],
        );
        batch.update(
          docs.reference,
          updatedMessage.toJson(),
        );
      }
      batch.commit();
      return;
    } catch (error) {
      print('Error updating post : $error');
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

// Mockup implementation of the Post repository
class MessageRepositoryMock implements IMessageRepository {
  @override
  Stream<List<Message>> getMessageStream(String groupId) {
    print('Mock - get Stream');
    final controller = StreamController<List<Message>>();
    List<Message> messages = [];
    messages.add(Message(
        userId: 'userId',
        userName: 'userName',
        groupId: groupId,
        text: 'text'));
    controller.add(List.from(messages));
    return controller.stream;
  }

  @override
  Future<void> addMessage(Message message) async {
    print('Mock - message added');
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    print('Mock - message deleted');
  }

  @override
  Future<void> updatePostUserName(String userId, String newName) async {
    print('Mock - message updated');
  }
}
