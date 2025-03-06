import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticketbox/infrastructure/repository/group_repository.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';
import 'package:ticketbox/infrastructure/datasource/auth_datasource.dart';

import 'group_repository_test.mocks.dart';

// Generating mocks using build_runner and mockito
@GenerateMocks([ApiDataSource, AuthDataSource, CollectionReference, Query, QuerySnapshot, QueryDocumentSnapshot, DocumentReference, User])
void main() {
  late GroupRepositoryImpl groupRepository;
  late MockApiDataSource mockApiDataSource;
  late MockAuthDataSource mockAuthDataSource;

  // Declare mocks for collections
  late MockCollectionReference mockGroupCollection;
  late MockCollectionReference mockMembershipCollection;
  late MockCollectionReference mockPostCollection;
  late MockCollectionReference mockMessageCollection;

  setUp(() {
    mockApiDataSource = MockApiDataSource();
    mockAuthDataSource = MockAuthDataSource();

    // Create separate mocks for collections
    mockGroupCollection = MockCollectionReference();
    mockMembershipCollection = MockCollectionReference();
    mockPostCollection = MockCollectionReference();
    mockMessageCollection = MockCollectionReference();

    // Ensure collections return mocked values
    when(mockApiDataSource.groupCollection).thenReturn(mockGroupCollection);
    when(mockApiDataSource.membershipCollection).thenReturn(mockMembershipCollection);
    when(mockApiDataSource.postCollection).thenReturn(mockPostCollection);
    when(mockApiDataSource.messageCollection).thenReturn(mockMessageCollection);

    final mockGroupRef = MockDocumentReference();
    when(mockGroupCollection.doc(any)).thenReturn(mockGroupRef);

    groupRepository = GroupRepositoryImpl(mockApiDataSource, mockAuthDataSource);
  });

  group('GroupRepositoryImpl Tests', () {
    test('addGroup returns error if user is null', () async {
      // Arrange
      when(mockAuthDataSource.getCurrentUser()).thenAnswer((_) async => null);

      // Act
      final result = await groupRepository.addGroup({'groupName': 'Test Group'});

      // Assert
      expect(result, 'Unable to find current user!');
    });

    test('addGroup creates group successfully', () async {
      // Arrange
      final mockUser = MockUser();
      when(mockUser.uid).thenReturn('user123');
      when(mockUser.displayName).thenReturn('Test User');
      when(mockAuthDataSource.getCurrentUser()).thenAnswer((_) async => mockUser);

      final mockGroupRef = MockDocumentReference(); // Mock group reference

      // Ensure `add()` returns a valid document reference
      when(mockGroupCollection.add(any)).thenAnswer((_) async => mockGroupRef);
      when(mockGroupRef.id).thenReturn('group123');

      // Mock membership collection addition
      when(mockMembershipCollection.add(any)).thenAnswer((_) async => MockDocumentReference());

      // Act
      final result = await groupRepository.addGroup({'groupName': 'Test Group'});

      // Assert
      expect(result, 'Group created!');
    });

    test('deleteGroup successfully deletes group', () async {
      // Arrange
      final mockGroupId = 'group123';

      // Mock Firestore Query and QuerySnapshot
      final mockMembershipQuery = MockQuery();
      final mockPostQuery = MockQuery();
      final mockMessageQuery = MockQuery();

      final mockMembershipSnapshot = MockQuerySnapshot();
      final mockPostSnapshot = MockQuerySnapshot();
      final mockMessageSnapshot = MockQuerySnapshot();

      final mockMembershipDoc = MockQueryDocumentSnapshot();
      final mockGroupRef = MockDocumentReference(); // Mock group reference

      // Mock the reference property of the query document snapshot
      final mockDocReference = MockDocumentReference();
      when(mockMembershipDoc.reference).thenReturn(mockDocReference);

      // Ensure `where()` returns a valid query for all collections
      when(mockMembershipCollection.where('groupId', isEqualTo: mockGroupId)).thenReturn(mockMembershipQuery);
      when(mockPostCollection.where('groupId', isEqualTo: mockGroupId)).thenReturn(mockPostQuery);
      when(mockMessageCollection.where('groupId', isEqualTo: mockGroupId)).thenReturn(mockMessageQuery);

      // Ensure `get()` returns a valid snapshot for all collections
      when(mockMembershipQuery.get()).thenAnswer((_) async => mockMembershipSnapshot);
      when(mockPostQuery.get()).thenAnswer((_) async => mockPostSnapshot);
      when(mockMessageQuery.get()).thenAnswer((_) async => mockMessageSnapshot);

      // Ensure `docs` returns a valid list of documents for all snapshots
      when(mockMembershipSnapshot.docs).thenReturn([mockMembershipDoc]);
      when(mockPostSnapshot.docs).thenReturn([mockMembershipDoc]);
      when(mockMessageSnapshot.docs).thenReturn([mockMembershipDoc]);

      // Ensure membership deletion works
      when(mockDocReference.delete()).thenAnswer((_) async {});

      // Ensure deleting the group itself works
      when(mockGroupCollection.doc(mockGroupId)).thenReturn(mockGroupRef);
      when(mockGroupRef.delete()).thenAnswer((_) async {});

      // Act
      await groupRepository.deleteGroup(mockGroupId);

      // Assert
      verify(mockGroupRef.delete()).called(1); // Ensure group is deleted
      verify(mockDocReference.delete()).called(3); // Ensure memberships, posts, and messages are deleted
    });

    test('updateGroup successfully updates group', () async {
      // Arrange
      final groupId = 'group123';
      final updateData = {'groupName': 'Updated Group'};
      final mockGroupRef = MockDocumentReference();

      // Ensure groupCollection is correctly mocked
      when(mockGroupCollection.doc(groupId)).thenReturn(mockGroupRef);

      // Act
      await groupRepository.updateGroup(groupId, updateData);

      // Assert
      verify(mockGroupRef.update(updateData)).called(1);  // Ensure the group is updated with the correct data
    });
  });
}
