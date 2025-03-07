import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';
import 'package:ticketbox/infrastructure/repository/tickettype_repository.dart';

import 'tickettype_repository_test.mocks.dart';

@GenerateMocks([
  ApiDataSource,
  CollectionReference,
  DocumentReference,
  Query,
  QuerySnapshot,
  QueryDocumentSnapshot
])
void main() {
  late MockApiDataSource mockApiDataSource;
  late MockCollectionReference mockCollectionReference;
  late MockQuery mockQuery;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockDocumentReference mockDocumentReference;
  late TicketTypeRepositoryImpl ticketTypeRepository;

  setUp(() {
    mockApiDataSource = MockApiDataSource();
    mockCollectionReference = MockCollectionReference();
    mockQuery = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    mockDocumentReference = MockDocumentReference();
    ticketTypeRepository = TicketTypeRepositoryImpl(mockApiDataSource);

    when(mockApiDataSource.ticketTypeCollection).thenReturn(mockCollectionReference);
  });

  group('TicketTypeRepositoryImpl', () {
    test('should add a ticket type and return document ID', () async {
      final ticketTypeData = {'ticketName': 'VIP', 'groupId': '123'};

      when(mockCollectionReference.add(ticketTypeData)).thenAnswer((_) async => mockDocumentReference);
      when(mockDocumentReference.id).thenReturn('mockTicketId');

      await ticketTypeRepository.addTicketType(ticketTypeData);

      verify(mockCollectionReference.add(ticketTypeData)).called(1);
    });

    test('should throw an error if adding a ticket type fails', () async {
      final ticketTypeData = {'ticketName': 'VIP', 'groupId': '123'};

      when(mockCollectionReference.add(ticketTypeData)).thenThrow(Exception('Add failed'));

      expect(() => ticketTypeRepository.addTicketType(ticketTypeData), throwsA(isA<String>()));
    });

    test('should update a ticket type', () async {
      final ticketId = '123';
      final newData = {'ticketName': 'Standard'};
      when(mockCollectionReference.doc(ticketId)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.update(newData)).thenAnswer((_) async {});

      await ticketTypeRepository.updateTicketType(ticketId, newData);

      verify(mockDocumentReference.update(newData)).called(1);
    });

    test('should throw an error if updating a ticket type fails', () async {
      final ticketId = '123';
      final newData = {'ticketName': 'Standard'};
      when(mockCollectionReference.doc(ticketId)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.update(newData)).thenThrow(Exception('Update failed'));
      expect(() => ticketTypeRepository.updateTicketType(ticketId, newData), throwsA(isA<String>()));
    });

    test('should delete a ticket type', () async {
      final ticketId = '123';
      when(mockCollectionReference.doc(ticketId)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.delete()).thenAnswer((_) async {});

      await ticketTypeRepository.deleteTicketType(ticketId);

      verify(mockDocumentReference.delete()).called(1);
    });

    test('should throw an error if deleting a ticket type fails', () async {
      final ticketId = '123';
      when(mockCollectionReference.doc(ticketId)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.delete()).thenThrow(Exception('Delete failed'));

      expect(() => ticketTypeRepository.deleteTicketType(ticketId), throwsA(isA<String>()));
    });

    test('should retrieve ticket types by groupId', () async {
      final groupId = '123';
      final ticketData = {'ticketName': 'VIP', 'groupId': groupId};

      when(mockCollectionReference.where('groupId', isEqualTo: groupId)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn(ticketData);
      when(mockQueryDocumentSnapshot.id).thenReturn('mockTicketId');

      final result = await ticketTypeRepository.getTicketTypesByGroupId(groupId);

      expect(result.length, 1);
      expect(result[0].ticketName, 'VIP');
      verify(mockCollectionReference.where('groupId', isEqualTo: groupId)).called(1);
      verify(mockQuery.get()).called(1);
    });

    test('should return an empty list if no tickets are found', () async {
      final groupId = '123';

      when(mockCollectionReference.where('groupId', isEqualTo: groupId)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([]);

      final result = await ticketTypeRepository.getTicketTypesByGroupId(groupId);

      expect(result, isEmpty);
    });

    test('should stream ticket types by groupId', () async {
      final groupId = '123';
      final ticketData = {'ticketName': 'VIP', 'groupId': groupId};

      when(mockCollectionReference.where('groupId', isEqualTo: groupId)).thenReturn(mockQuery);
      when(mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn(ticketData);
      when(mockQueryDocumentSnapshot.id).thenReturn('mockTicketId');

      final stream = ticketTypeRepository.getTicketTypesByGroupIdStream(groupId);
      final result = await stream.first;

      expect(result.length, 1);
      expect(result[0].ticketName, 'VIP');
      verify(mockCollectionReference.where('groupId', isEqualTo: groupId)).called(1);
      verify(mockQuery.snapshots()).called(1);
    });

    test('should return an empty list if no ticket types exist in stream', () async {
      final groupId = '123';

      when(mockCollectionReference.where('groupId', isEqualTo: groupId)).thenReturn(mockQuery);
      when(mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
      when(mockQuerySnapshot.docs).thenReturn([]);

      final stream = ticketTypeRepository.getTicketTypesByGroupIdStream(groupId);
      final result = await stream.first;

      expect(result, isEmpty);
    });
  });
}
