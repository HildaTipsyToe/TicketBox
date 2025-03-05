import 'package:firebase_auth/firebase_auth.dart';

import '../../config/injection_container.dart';
import '../../domain/entities/settings.dart';
import '../../domain/entities/user.dart';
import '../datasource/auth_datasource.dart';

/// Abstract class that represent the authentication reposistory
///
/// This interface defines the contract for authentication-related data operations.
abstract class IAuthRepository {
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<User?> getCurrentUser();
  Future<void> forgotPassword(String email);
  Future<void> createUser(String name, String email, String password);
  Future<void> signOut();
}

// Mockup implementation of the auth repository
class AuthRepositoryMock extends IAuthRepository {

  @override
  signInWithEmailAndPassword(String email, String password) async {
    print('Mock - signin with $email and $password' );
    sl<TBSettings>().isLoggedIn = true;
    sl<TBUser>().userId = 'userId';
    sl<TBUser>().userName = 'username';
    sl<TBUser>().userMail = email;
  }

  @override
  getCurrentUser() async {
    print('Mock - get current user');
    return null;
  }

  @override
  Future<void> forgotPassword(String email) async {
    print('Mock - forget password for $email');
  }

  @override
  Future<void> createUser(String name, String email, String password) async {
    print('Mock create user');
  }

  @override
  Future<void> signOut() async {
    sl<TBSettings>().isLoggedIn = false;
    print('Mock - log out');
  }
}

// Concrete implementation of auth repository
class AuthRepositoryImpl extends IAuthRepository {
  final AuthDataSource authDataSource;
  final TBSettings settings; // Inject TBSettings instead of using GetIt

  AuthRepositoryImpl(this.authDataSource, this.settings);

  @override
  signInWithEmailAndPassword(String email, String password) async {
    try {
      await authDataSource.signInWithEmailAndPassword(email, password);
    }
    on FirebaseAuthException catch (error) {
      throw AuthError(message: error.message, code: error.code);
    }
  }

  @override
  getCurrentUser() async {
    return authDataSource.getCurrentUser();
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await authDataSource.forgotPassword(email);
    }
    on FirebaseAuthException catch (error) {
      throw AuthError(message: error.message, code: error.code);
    }
  }

  @override
  Future<void> createUser(String name, String email, String password) async {
    try {
      await authDataSource.createUser(name, email, password);
    }
    on FirebaseAuthException catch (error) {
    throw AuthError(message: error.message, code: error.code);
    }
  }

  @override
  Future<void> signOut() async {
    settings.isLoggedIn = false;
    await authDataSource.signOut();
  }
}

// Definitions of authentication errors from firebase
class AuthError implements Exception {
  final String? message;
  final String? code;

  AuthError({this.message, this.code});

  String get displayErrMsg {
    /// - **account-exists-with-different-credential**:
    ///  - Thrown if there already exists an account with the email address
    ///    asserted by the credential.
    ///    Resolve this by calling [fetchSignInMethodsForEmail] and then asking
    ///    the user to sign in using one of the returned providers.
    ///    Once the user is signed in, the original credential can be linked to
    ///    the user with [linkWithCredential].
    /// - **invalid-credential**:
    ///  - Thrown if the credential is malformed or has expired.
    /// - **operation-not-allowed**:
    ///  - Thrown if the type of account corresponding to the credential is not
    ///    enabled. Enable the account type in the Firebase Console, under the
    ///    Auth tab.
    /// - **user-disabled**:
    ///  - Thrown if the user corresponding to the given credential has been
    ///    disabled.
    /// - **user-not-found**:
    ///  - Thrown if signing in with a credential from [EmailAuthProvider.credential]
    ///    and there is no user corresponding to the given email.
    /// - **wrong-password**:
    ///  - Thrown if signing in with a credential from [EmailAuthProvider.credential]
    ///    and the password is invalid for the given email, or if the account
    ///    corresponding to the email does not have a password set.
    /// - **invalid-verification-code**:
    ///  - Thrown if the credential is a [PhoneAuthProvider.credential] and the
    ///    verification code of the credential is not valid.
    /// - **invalid-verification-id**:
    ///  - Thrown if the credential is a [PhoneAuthProvider.credential] and the
    ///    verification ID of the credential is not valid.id.
    switch (code) {
      case 'user-not-found':
      case 'user-disabled':
        return 'Bruger findes ikke';
      case 'wrong-password':
        return 'Brugernavn eller password er forkert...';
      default:
        return displayUnexpectedErrorMsg;
    }
  }

  String get displayUnexpectedErrorMsg =>
      'Der er sket en ukendt fejl. Prøv igen.';
}
