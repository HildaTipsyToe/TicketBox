// Abstract repository interface for Post
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketbox/domain/entities/message.dart';

import '../datasource/api_datasource.dart';

abstract class IMessageRepository {
  Future<List<Message>> getMessagesByGroupId(String groupId);
  Stream<QuerySnapshot> getMessageStream(String groupId);
  Future<void> addMessage(Message message);
  Future<void> deleteMessage(Message message);
}
class MessageRepositoryMock implements IMessageRepository {
  @override
  Future<void> addMessage(Message message) async {
    // TODO: implement addMessage
  }

  @override
  Future<void> deleteMessage(Message message) async {
    // TODO: implement deleteMessage
  }

  @override
  Future<List<Message>> getMessagesByGroupId(String groupId) async {
    List<Message> messages = [
      Message(userId: 'xxx', userName: 'xxx', groupId: groupId, timeStamp: Timestamp.fromDate(DateTime.parse('01-01-2025')), text: 'text1'),
      Message(userId: 'yyy', userName: 'yyy', groupId: groupId, timeStamp: Timestamp.fromDate(DateTime.parse('02-01-2025')), text: 'text2')
    ];
    return messages;
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

  @override
  Future<List<Message>> getMessagesByGroupId(String groupId) async {
    // Query the message collection where the specified field matches the provided value
    QuerySnapshot querySnapshot = await _apiDataSource.messageCollection
        .where('groupId', isEqualTo: groupId)
        .orderBy('timeStamp', descending: true)
        .get();

    // Map the documents to the Message model
    List<Message> messages = querySnapshot.docs
        .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>)
        .copyWith(messageId: doc.id))
        .toList();

    return messages;
  }

  @override
  Stream<QuerySnapshot> getMessageStream(String groupId) {
    return _apiDataSource.messageCollection
        .where('groupId', isEqualTo: groupId)
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

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

  @override
  Future<void> deleteMessage(Message message) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      // Reference to the message to be deleted
      DocumentReference messageRef =
      _apiDataSource.messageCollection.doc(message.messageId);

      // Delete the message
      batch.delete(messageRef);

      // Commit the batch operation
      await batch.commit();
    } catch (e) {
      print('Error deleting post and updating memberships: $e');
    }
  }
}
