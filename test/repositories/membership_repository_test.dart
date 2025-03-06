import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticketbox/infrastructure/repository/group_repository.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';
import 'package:ticketbox/infrastructure/datasource/auth_datasource.dart';
import 'package:ticketbox/domain/entities/membership.dart';

import 'group_repository_test.mocks.dart';

// Generating mocks using build_runner and mockito
@GenerateMocks([ApiDataSource, AuthDataSource, CollectionReference, Query, QuerySnapshot, QueryDocumentSnapshot, DocumentReference, User])
void main() {
  late GroupRepositoryImpl repository;
  late MockApiDataSource mockApiDataSource;
  late MockAuthDataSource mockAuthDataSource;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockDocumentReference mockDocumentReference;
  late MockQuery mockQuery;
  late MockCollectionReference mockGroupCollection;
  late MockCollectionReference mockMembershipCollection;

  setUp(() {
    // Initialize the mocks before each test
    mockApiDataSource = MockApiDataSource();
    mockAuthDataSource = MockAuthDataSource();
    repository = GroupRepositoryImpl(mockApiDataSource, mockAuthDataSource);

    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    mockDocumentReference = MockDocumentReference();
    mockQuery = MockQuery();

    // Mock the groupCollection to return a mock CollectionReference
    mockGroupCollection = MockCollectionReference();
    when(mockApiDataSource.groupCollection).thenReturn(mockGroupCollection);

    // Stub add operation on mock groupCollection to return a mock DocumentReference
    when(mockGroupCollection.add(any)).thenAnswer((_) async => mockDocumentReference);

    // Mock the membership collection
    mockMembershipCollection = MockCollectionReference();
    when(mockApiDataSource.membershipCollection).thenReturn(mockMembershipCollection);
  });

  test('addGroup should return "Group created!" when successful', () async {
    // Mocking current user
    final mockUser = MockUser();
    when(mockAuthDataSource.getCurrentUser()).thenAnswer((_) async => mockUser);
    when(mockUser.uid).thenReturn('mock_user_id');
    when(mockUser.displayName).thenReturn('mock_user_name');

    final groupData = {'groupName': 'Test Group'};
    final mockGroupRef = MockDocumentReference();

    // Mocking Firestore collection and add operation
    when(mockGroupCollection.add(groupData))
        .thenAnswer((_) async => mockGroupRef);
    when(mockGroupRef.id).thenReturn('mock_group_id');

    // Mocking the membership collection add
    final mockMembership = Membership(
      userId: 'mock_user_id',
      userName: 'mock_user_name',
      groupId: 'mock_group_id',
      groupName: 'Test Group',
      balance: 0,
      roleId: 1,
    );
    when(mockMembershipCollection.add(mockMembership.toJson()))
        .thenAnswer((_) async => mockDocumentReference);

    // Act
    final result = await repository.addGroup(groupData);

    // Assert
    expect(result, 'Group created!');
  });

  test('deleteGroup should delete all related documents when successful', () async {
    final groupId = 'mock_group_id';

    // Mocking the Firestore snapshots for memberships, posts, and messages
    when(mockApiDataSource.membershipCollection.where('groupId', isEqualTo: groupId))
        .thenReturn(mockQuery);
    when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);

    when(mockApiDataSource.postCollection.where('groupId', isEqualTo: groupId))
        .thenReturn(mockQuery);
    when(mockApiDataSource.messageCollection.where('groupId', isEqualTo: groupId))
        .thenReturn(mockQuery);

    // Mocking the delete operation for each reference
    when(mockQueryDocumentSnapshot.reference).thenReturn(mockDocumentReference);
    when(mockDocumentReference.delete()).thenAnswer((_) async {});

    // Act
    await repository.deleteGroup(groupId);

    // Assert
    // Verifying delete was called 4 times (for membership, post, message, and group)
    verify(mockDocumentReference.delete()).called(4);
  });
}
