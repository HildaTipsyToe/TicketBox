import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ticketbox/domain/entities/settings.dart';
import 'package:ticketbox/domain/entities/user.dart';
import 'package:ticketbox/infrastructure/datasource/auth_datasource.dart';
import 'package:ticketbox/infrastructure/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For FirebaseAuthException
import 'package:ticketbox/infrastructure/repository/user_repository.dart';
import 'auth_repository_test.mocks.dart'; // Importer den genererede fil med mocks

@GenerateMocks([AuthDataSource, User, TBSettings, TBUser, IUserRepository])
void main() {
  late AuthRepositoryImpl authRepository;
  late MockAuthDataSource mockAuthDataSource;
  late MockUser mockUser; // Mock af User
  late MockTBUser mockTBUser;
  late MockTBSettings mockTBSettings; // Mock af TBSettings
  late MockIUserRepository mockIUserRepository;

  setUp(() {
    // Initialisering af mocks
    mockAuthDataSource = MockAuthDataSource();
    mockTBSettings = MockTBSettings();
    mockUser = MockUser();
    mockTBUser = MockTBUser();
    mockIUserRepository = MockIUserRepository();
    authRepository = AuthRepositoryImpl(mockAuthDataSource, mockTBSettings, mockIUserRepository, mockTBUser);
  });

  group('AuthRepositoryImpl', () {
    test('should sign in with email and password', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';

      when(mockAuthDataSource.signInWithEmailAndPassword(email, password))
          .thenAnswer((_) async {}); // Mocking signIn
      when(mockIUserRepository.getUserByEmail(email))
          .thenAnswer((_) async => mockTBUser);
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

    test('should create user and call both authDataSource and userRepository', () async {
      // Arrange
      final name = 'John Doe';
      final email = 'test@example.com';
      final password = 'password123';
      const userId = 'mockUserId';

      when(mockAuthDataSource.createUser(name, email, password))
          .thenAnswer((_) async {});

      when(mockAuthDataSource.getCurrentUser())
          .thenAnswer((_) async => MockUser());

      when(mockTBUser.userId).thenReturn('mockUserId');
      when(mockIUserRepository.createUser(userId, name, email))
          .thenAnswer((_) async {});

      // Act
      await authRepository.createUser(name, email, password);

      // Assert
      verify(mockAuthDataSource.createUser(name, email, password)).called(1);
      verify(mockIUserRepository.createUser(userId, name, email)).called(1);
    });


    test('should update display name', () async {
      // Arrange
      const String newDisplayName = 'Updated User';

      // Mock the updateDisplayName method in AuthDataSource
      when(mockAuthDataSource.updateDisplayName(newDisplayName))
          .thenAnswer((_) async {});  // Simulate the update without errors

      // Act
      await authRepository.updateDisplayName(newDisplayName);

      // Assert
      verify(mockAuthDataSource.updateDisplayName(newDisplayName)).called(1);  // Ensure the method is called with the expected parameter
    });
  });
}
