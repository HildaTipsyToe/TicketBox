import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ticketbox/domain/entities/settings.dart';
import 'package:ticketbox/infrastructure/datasource/auth_datasource.dart';
import 'package:ticketbox/infrastructure/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For FirebaseAuthException
import 'auth_repository_test.mocks.dart'; // Importer den genererede fil med mocks

@GenerateMocks([AuthDataSource, User, TBSettings])
void main() {
  late AuthRepositoryImpl authRepository;
  late MockAuthDataSource mockAuthDataSource;
  late MockUser mockTBUser; // Mock af User
  late MockTBSettings mockTBSettings; // Mock af TBSettings

  setUp(() {
    // Initialisering af mocks
    mockAuthDataSource = MockAuthDataSource();
    mockTBSettings = MockTBSettings();
    mockTBUser = MockUser();  // Mock af TBUser
    authRepository = AuthRepositoryImpl(mockAuthDataSource, mockTBSettings);
  });

  group('AuthRepositoryImpl', () {
    test('should sign in with email and password', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';

      when(mockAuthDataSource.signInWithEmailAndPassword(email, password))
          .thenAnswer((_) async {}); // Mocking signIn

      // Act
      await authRepository.signInWithEmailAndPassword(email, password);

      // Assert
      verify(mockAuthDataSource.signInWithEmailAndPassword(email, password)).called(1);
    });

    test('should throw AuthError when FirebaseAuthException is thrown', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';
      final exception = FirebaseAuthException(
        code: 'wrong-password',
        message: 'Invalid password',
      );

      when(mockAuthDataSource.signInWithEmailAndPassword(email, password))
          .thenThrow(exception); // Mocking an error

      // Act & Assert
      expect(() => authRepository.signInWithEmailAndPassword(email, password),
        throwsA(isA<AuthError>()),
      );
    });

    test('should return current user', () async {
      // Arrange
      final mockUser = mockTBUser;
      when(mockAuthDataSource.getCurrentUser()).thenAnswer((_) async => mockUser);

      // Act
      final user = await authRepository.getCurrentUser();

      // Assert
      expect(user, mockUser);
      verify(mockAuthDataSource.getCurrentUser()).called(1);
    });

    test('should sign out', () async {
      // Arrange
      when(mockAuthDataSource.signOut()).thenAnswer((_) async {});

      // Act
      await authRepository.signOut();

      // Assert
      verify(mockAuthDataSource.signOut()).called(1);
    });

    test('should handle forgot password', () async {
      // Arrange
      final email = 'test@example.com';
      when(mockAuthDataSource.forgotPassword(email)).thenAnswer((_) async {});

      // Act
      await authRepository.forgotPassword(email);

      // Assert
      verify(mockAuthDataSource.forgotPassword(email)).called(1);
    });

    test('should create user', () async {
      // Arrange
      final name = 'John Doe';
      final email = 'test@example.com';
      final password = 'password123';
      when(mockAuthDataSource.createUser(name, email, password))
          .thenAnswer((_) async {});

      // Act
      await authRepository.createUser(name, email, password);

      // Assert
      verify(mockAuthDataSource.createUser(name, email, password)).called(1);
    });
  });
}
