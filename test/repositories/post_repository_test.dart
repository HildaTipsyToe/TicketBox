import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ticketbox/domain/entities/post.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';
import 'package:ticketbox/infrastructure/repository/post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_repository_test.mocks.dart';  // Importer de genererede mocks

@GenerateMocks([ApiDataSource, CollectionReference, DocumentReference, Query, QuerySnapshot, QueryDocumentSnapshot])

void main() {
  group('PostRepositoryImpl', () {
    late PostRepositoryImpl repository;
    late MockApiDataSource mockApiDataSource;
    late MockQuerySnapshot mockQuerySnapshot;
    late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
    late MockDocumentReference mockDocumentReference;
    late MockCollectionReference mockCollectionReference;
    late MockQuery mockQuery;

    setUp(() {
      mockApiDataSource = MockApiDataSource();
      mockQuerySnapshot = MockQuerySnapshot();
      mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
      mockDocumentReference = MockDocumentReference();
      mockCollectionReference = MockCollectionReference();
      mockQuery = MockQuery();
      repository = PostRepositoryImpl(mockApiDataSource);

      when(mockApiDataSource.postCollection).thenReturn(mockCollectionReference);
      when(mockApiDataSource.membershipCollection).thenReturn(mockCollectionReference);

      when(mockCollectionReference.where('groupId', isEqualTo: anyNamed('isEqualTo')))
          .thenReturn(mockQuery);
      when(mockQuery.where('userId', isEqualTo: anyNamed('isEqualTo')))
          .thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn({'balance': 100});
      when(mockQueryDocumentSnapshot.reference).thenReturn(mockDocumentReference);
      when(mockDocumentReference.update(any)).thenAnswer((_) async {});

    });

    test('addPost should add post to Firestore', () async {
      final post = Post(
        postId: '1',
        adminId: 'adminId',
        adminName: 'adminName',
        groupId: 'groupId',
        price: 100,
        receiverId: 'receiverId',
        receiverName: 'receiverName',
        ticketTypeId: 'ticketTypeId',
        ticketTypeName: 'ticketTypeName',
      );

      when(mockCollectionReference.add(post.toJson())).thenAnswer((_) async => mockDocumentReference);

      await repository.addPost(post);

      verify(mockCollectionReference.add(post.toJson())).called(1);  // Verificér at posten bliver tilføjet
    });

    test('deletePost should delete a post and update the balance', () async {
      final post = Post(
        postId: '1',
        adminId: 'adminId',
        adminName: 'adminName',
        groupId: 'groupId',
        price: 100,
        receiverId: 'receiverId',
        receiverName: 'receiverName',
        ticketTypeId: 'ticketTypeId',
        ticketTypeName: 'ticketTypeName',
      );

      when(mockCollectionReference.doc(post.postId)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.delete()).thenAnswer((_) async {});
      when(mockCollectionReference.where('groupId', isEqualTo: post.groupId)).thenReturn(mockQuery);
      when(mockQuery.where('userId', isEqualTo: post.receiverId)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn({'balance': 100});
      when(mockQueryDocumentSnapshot.reference).thenReturn(mockDocumentReference);
      when(mockDocumentReference.update(any)).thenAnswer((_) async {});

      await repository.deletePost(post);

      verify(mockDocumentReference.delete()).called(1);  // Verificer delete blev kaldt én gang
      verify(mockDocumentReference.update({'balance': 200})).called(1);  // Verificer at update blev kaldt med korrekt balance
    });

    test('deletePost should throw an error when deletion fails', () async {
      final post = Post(
        postId: '1',
        adminId: 'adminId',
        adminName: 'adminName',
        groupId: 'groupId',
        price: 100,
        receiverId: 'receiverId',
        receiverName: 'receiverName',
        ticketTypeId: 'ticketTypeId',
        ticketTypeName: 'ticketTypeName',
      );

      when(mockCollectionReference.doc(post.postId)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.delete()).thenThrow(Exception('Error deleting post'));

      expect(() async => await repository.deletePost(post), throwsException);
    });
  });
}