import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticketbox/domain/entities/message.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';
import 'package:ticketbox/infrastructure/repository/message_repository.dart';
import 'post_repository_test.mocks.dart';

@GenerateMocks([ApiDataSource, CollectionReference, DocumentReference, QuerySnapshot, QueryDocumentSnapshot])


void main() {
  late MessageRepositoryImpl messageRepository;
  late MockApiDataSource mockApiDataSource;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockApiDataSource = MockApiDataSource();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    messageRepository = MessageRepositoryImpl(mockApiDataSource);

    when(mockApiDataSource.messageCollection).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
  });

  group('MessageRepositoryImpl Tests', () {
    test('addMessage calls set on message collection', () async {
      // Arrange
      final message = Message(userId: 'userId', userName: 'userName', groupId: 'groupId', text: 'Hello');

      // Act
      await messageRepository.addMessage(message);

      // Assert
      verify(mockDocumentReference.set(message.toJson())).called(1);
    });

    test('deleteMessage calls delete on message collection', () async {
      // Arrange
      const messageId = 'messageId';

      // Act
      await messageRepository.deleteMessage(messageId);

      // Assert
      verify(mockDocumentReference.delete()).called(1);
    });

    test('getMessageStream streams messages from collection', () async {
      // Arrange
      const groupId = 'groupId';
      final querySnapshot = MockQuerySnapshot();
      final queryDocumentSnapshot = MockQueryDocumentSnapshot();

      when(mockCollectionReference.where(any, isEqualTo: anyNamed('isEqualTo')))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.orderBy(any, descending: anyNamed('descending')))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.snapshots()).thenAnswer((_) => Stream.value(querySnapshot));
      when(querySnapshot.docs).thenReturn([queryDocumentSnapshot]);
      when(queryDocumentSnapshot.id).thenReturn('docId');
      when(queryDocumentSnapshot.data()).thenReturn({'userId': 'userId', 'userName': 'userName', 'groupId': groupId, 'text': 'text'});

      // Act
      final stream = messageRepository.getMessageStream(groupId);
      final messages = await stream.first;

      // Assert
      expect(messages.length, 1);
      expect(messages[0].userId, 'userId');
      expect(messages[0].text, 'text');
    });
  });
}