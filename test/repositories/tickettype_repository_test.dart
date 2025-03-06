import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';
import 'package:ticketbox/infrastructure/repository/tickettype_repository.dart';

import 'tickettype_repository_test.mocks.dart';

// Generer mocks af de nødvendige Firestore klasser
@GenerateMocks([ApiDataSource, CollectionReference, DocumentReference, Query, QuerySnapshot, QueryDocumentSnapshot])
void main() {
  late MockApiDataSource mockApiDataSource;
  late MockCollectionReference mockCollectionReference;
  late MockQuery mockQuery;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late TicketTypeRepositoryImpl ticketTypeRepository;

  setUp(() {
    mockApiDataSource = MockApiDataSource();
    mockCollectionReference = MockCollectionReference();
    mockQuery = MockQuery();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    ticketTypeRepository = TicketTypeRepositoryImpl(mockApiDataSource);

    when(mockApiDataSource.ticketTypeCollection).thenReturn(mockCollectionReference);
  });

  group('TicketTypeRepositoryImpl', () {
    test('should add a ticket type', () async {
      final ticketTypeData = {'ticketName': 'VIP', 'groupId': '123'};
      when(mockCollectionReference.add(ticketTypeData)).thenAnswer((_) async => MockDocumentReference());

      await ticketTypeRepository.addTicketType(ticketTypeData);

      verify(mockCollectionReference.add(ticketTypeData)).called(1);
    });

    test('should update a ticket type', () async {
      final ticketId = '123';
      final newData = {'ticketName': 'Standard'};
      final mockDocRef = MockDocumentReference();
      when(mockCollectionReference.doc(ticketId)).thenReturn(mockDocRef);
      when(mockDocRef.update(newData)).thenAnswer((_) async => Future.value());

      await ticketTypeRepository.updateTicketType(ticketId, newData);

      verify(mockDocRef.update(newData)).called(1);
    });

    test('should delete a ticket type', () async {
      final ticketId = '123';
      final mockDocRef = MockDocumentReference();
      when(mockCollectionReference.doc(ticketId)).thenReturn(mockDocRef);
      when(mockDocRef.delete()).thenAnswer((_) async => Future.value());

      await ticketTypeRepository.deleteTicketType(ticketId);

      verify(mockDocRef.delete()).called(1);
    });

    test('should retrieve ticket types by groupId', () async {
      final groupId = '123';
      final ticketData = [
        {'ticketName': 'VIP', 'groupId': groupId}
      ];
      final querySnapshot = MockQuerySnapshot();
      when(mockCollectionReference.where('groupId', isEqualTo: groupId)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => querySnapshot);
      when(querySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn(ticketData[0]);
      when(mockQueryDocumentSnapshot.id).thenReturn('mockTicketId');

      final result = await ticketTypeRepository.getTicketTypesByGroupId(groupId);

      expect(result.length, 1);
      expect(result[0].ticketName, 'VIP');
      verify(mockCollectionReference.where('groupId', isEqualTo: groupId)).called(1);
      verify(mockQuery.get()).called(1);
    });

    test('should stream ticket types by groupId', () async {
      final groupId = '123';
      final ticketData = [
        {'ticketName': 'VIP', 'groupId': groupId}
      ];
      final querySnapshot = MockQuerySnapshot();
      when(mockCollectionReference.where('groupId', isEqualTo: groupId)).thenReturn(mockQuery);
      when(mockQuery.snapshots()).thenAnswer((_) => Stream.value(querySnapshot));
      when(querySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn(ticketData[0]);
      when(mockQueryDocumentSnapshot.id).thenReturn('mockTicketId');

      final stream = ticketTypeRepository.getTicketTypesByGroupIdStream(groupId);
      final result = await stream.first;

      expect(result.length, 1);
      expect(result[0].ticketName, 'VIP');
      verify(mockCollectionReference.where('groupId', isEqualTo: groupId)).called(1);
      verify(mockQuery.snapshots()).called(1);
    });
  });
}
