import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticketbox/domain/entities/settings.dart';
import 'package:ticketbox/domain/entities/user.dart';
import 'package:ticketbox/infrastructure/datasource/auth_datasource.dart';
import 'package:ticketbox/infrastructure/repository/auth_repository.dart';

import 'auth_datasource_test.mocks.dart';

@GenerateMocks([FirebaseAuth, User, TBUser, UserCredential, TBSettings])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockTBUser mockTBUser;
  late MockUser mockUser;
  late FirebaseAuthDataSource authDataSource;
  late MockTBSettings mockTBSettings; // Mock af TBSettings


  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockTBUser = MockTBUser();
    mockTBSettings = MockTBSettings();
    authDataSource = FirebaseAuthDataSource(firebaseAuth: mockFirebaseAuth, settings: mockTBSettings, user: mockTBUser);
  });

  group('authStatus', () {
    test('should return stream of auth state changes', () {
      when(mockFirebaseAuth.authStateChanges()).thenAnswer((_) => Stream.value(mockUser));

      expect(authDataSource.authStatus, emits(mockUser));
    });
  });

  group('getCurrentUser', () {
    test('should return current user when logged in', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('123');
      when(mockUser.displayName).thenReturn('Test User');
      when(mockUser.email).thenReturn('test@example.com');

      final user = await authDataSource.getCurrentUser();

      expect(user, equals(mockUser));
    });

    test('should return null when no user is logged in', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      final user = await authDataSource.getCurrentUser();

      expect(user, isNull);
    });
  });

  group('signOut', () {
    test('should call signOut on FirebaseAuth', () async {
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await authDataSource.signOut();

      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });

  group('signInWithEmailAndPassword', () {
    test('should call FirebaseAuth signInWithEmailAndPassword', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('123');
      when(mockUser.displayName).thenReturn('Test User');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => MockUserCredential());

      await authDataSource.signInWithEmailAndPassword('test@example.com', 'password123');

      verify(mockFirebaseAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password123')).called(1);
    });

    test('should throw AuthError on FirebaseAuthException', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'user-not-found', message: 'No user found'));

      expect(
            () => authDataSource.signInWithEmailAndPassword('test@example.com', 'password123'),
        throwsA(isA<AuthError>()),
      );
    });
  });

  group('createUser', () {
    test('should create a new user and update display name', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('123');
      when(mockUser.displayName).thenReturn('Test User');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => MockUserCredential());
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.updateDisplayName(any)).thenAnswer((_) async {});

      await authDataSource.createUser('Test User', 'test@example.com', 'password123');

      verify(mockFirebaseAuth.createUserWithEmailAndPassword(email: 'test@example.com', password: 'password123')).called(1);
      verify(mockUser.updateDisplayName('Test User')).called(1);
    });
  });

  group('forgotPassword', () {
    test('should send password reset email', () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email'))).thenAnswer((_) async {});

      await authDataSource.forgotPassword('test@example.com');

      verify(mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com')).called(1);
    });

    test('should throw AuthError on FirebaseAuthException', () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
          .thenThrow(FirebaseAuthException(code: 'invalid-email', message: 'Invalid email'));

      expect(() => authDataSource.forgotPassword('test@example.com'), throwsA(isA<AuthError>()));
    });
  });

  group('updateDisplayName', () {
    test('should update display name', () async {
      // Arrange
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('123');  // Mocking the 'uid' property
      when(mockUser.email).thenReturn('example@example.com');
      when(mockUser.displayName).thenReturn('Old Name');  // Mocking the 'displayName' property
      when(mockUser.updateDisplayName(any)).thenAnswer((_) async {});
      when(mockUser.reload()).thenAnswer((_) async {});  // If you want to mock reload as well

      // Act
      await authDataSource.updateDisplayName('New Display Name');

      // Assert
      verify(mockUser.updateDisplayName('New Display Name')).called(1);
    });

    test('should throw AuthError on FirebaseAuthException', () async {
      // Arrange
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.updateDisplayName(any)).thenThrow(FirebaseAuthException(code: 'error', message: 'Error message'));

      // Act
      final result = authDataSource.updateDisplayName('New Display Name');

      // Assert
      expect(result, throwsA(isA<AuthError>()));
    });
  });

}
