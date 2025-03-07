import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';
import 'package:ticketbox/infrastructure/datasource/auth_datasource.dart';
import 'package:ticketbox/infrastructure/repository/user_repository.dart';
import 'user_repository_test.mocks.dart';

@GenerateMocks([ApiDataSource, AuthDataSource, CollectionReference, DocumentReference, Query, QuerySnapshot, QueryDocumentSnapshot])
void main() {
  late UserRepositoryImpl userRepository;
  late MockApiDataSource mockApiDataSource;
  late MockAuthDataSource mockAuthDataSource;
  late MockCollectionReference mockUserCollection;
  late MockDocumentReference mockDocumentReference;
  late MockQuery mockQuery;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;

  setUp(() {
    mockApiDataSource = MockApiDataSource();
    mockAuthDataSource = MockAuthDataSource();
    mockUserCollection = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockQuery = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();

    // Mock user collection reference
    when(mockApiDataSource.userCollection).thenReturn(mockUserCollection);
    userRepository = UserRepositoryImpl(mockApiDataSource, mockAuthDataSource);
  });

  group('getUserByEmail', () {
    test('should return TBUser when user is found', () async {
      // Arrange
      const String email = 'test@example.com';

      // Mock collection reference
      when(mockUserCollection.where('userMail', isEqualTo: email))
          .thenReturn(mockQuery);
      when(mockQuery.limit(1)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.id).thenReturn('123');
      when(mockQueryDocumentSnapshot.data()).thenReturn({
        'userName': 'Test User',
        'userMail': email,
      });

      // Act
      final result = await userRepository.getUserByEmail(email);

      // Assert
      expect(result, isNotNull);
      expect(result!.userId, '123');
      expect(result.userName, 'Test User');
      expect(result.userMail, email);
    });


    test('should return null when no user is found', () async {
      // Arrange
      const String email = 'unknown@example.com';
      when(mockUserCollection.where('userMail', isEqualTo: email))
          .thenReturn(mockQuery);
      when(mockQuery.limit(1)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);

      when(mockQuerySnapshot.docs).thenReturn([]);

      // Act
      final result = await userRepository.getUserByEmail(email);

      // Assert
      expect(result, isNull);
    });

    test('should log an error and return null when an exception occurs', () async {
      // Arrange
      const String email = 'error@example.com';
      when(mockUserCollection.where('userMail', isEqualTo: email))
          .thenThrow(Exception('Firestore error'));

      // Act
      final result = await userRepository.getUserByEmail(email);

      // Assert
      expect(result, isNull);
    });
  });

  group('createUser', () {
    test('should call Firestore set method with correct data', () async {
      // Arrange
      const String uid = 'user123';
      const String name = 'New User';
      const String email = 'new@example.com';

      when(mockUserCollection.doc(uid)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.set(any)).thenAnswer((_) async {});

      // Act
      await userRepository.createUser(uid, name, email);

      // Assert
      verify(mockDocumentReference.set({
        'userName': name,
        'userMail': email.toLowerCase(),
      })).called(1);
    });

    test('should log an error when an exception occurs', () async {
      // Arrange
      const String uid = 'user123';
      const String name = 'New User';
      const String email = 'new@example.com';

      when(mockUserCollection.doc(uid)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.set(any)).thenThrow(Exception('Firestore error'));

      // Act
      await userRepository.createUser(uid, name, email);

      // Assert
      verify(mockDocumentReference.set(any)).called(1);
    });
  });

  group('updateUserName', () {
    test('should call Firestore update method with new userName and update display name', () async {
      // Arrange
      const String userId = 'user123';
      const String newUserName = 'Updated Name';

      // Mock the methods to return successful futures
      when(mockUserCollection.doc(userId)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.update(any)).thenAnswer((_) async {});
      when(mockAuthDataSource.updateDisplayName(newUserName)).thenAnswer((_) async {}); // Mocking updateDisplayName call

      // Act
      await userRepository.updateUserName(userId, newUserName);

      // Assert
      // Verify that updateDisplayName is called with the correct newUserName
      verify(mockAuthDataSource.updateDisplayName(newUserName)).called(1);

      // Verify that the Firestore update method is called with the correct parameters
      verify(mockDocumentReference.update({'userName': newUserName})).called(1);
    });

    test('should log an error when an exception occurs', () async {
      // Arrange
      const String userId = 'user123';
      const String newUserName = 'Updated Name';

      // Mock the methods to simulate exceptions
      when(mockUserCollection.doc(userId)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.update(any)).thenThrow(Exception('Firestore error'));
      when(mockAuthDataSource.updateDisplayName(newUserName)).thenAnswer((_) async {}); // Ensure this is mocked

      // Act
      await userRepository.updateUserName(userId, newUserName);

      // Assert
      // Verify that the Firestore update method was called once even though an error occurred
      verify(mockDocumentReference.update(any)).called(1);

      // You can optionally verify if logging is done by mocking the log method if necessary.
      // If you want to ensure logging, you can add a mock or check logs.
    });
  });

}
