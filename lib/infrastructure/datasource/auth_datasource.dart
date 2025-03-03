import 'package:firebase_auth/firebase_auth.dart';

import '../../config/injection_container.dart';

import '../../domain/entities/settings.dart';
import '../../domain/entities/user.dart';
import '../repository/auth_repository.dart';

/// Class that represent the Auth Datasource
///
/// The [Auth Datasource] have methods for:
/// - Sign in with [email] and [password]
/// - Get the current user
/// - Create user by [name], [email] and [password]
/// - Send an email where the user can reset a password by [email]
/// - Sign out current user
abstract class AuthDataSource {

  Stream<User?> get authStatus;

  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<User?> getCurrentUser();
  Future<void> createUser(String name, String email, String password);
  Future<void> forgotPassword(String email);
  Future<void> signOut();

}

class FirebaseAuthDataSource extends AuthDataSource {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthDataSource({required this.firebaseAuth});


  @override
  Stream<User?> get authStatus => firebaseAuth.authStateChanges();

  @override
  Future<User?> getCurrentUser() async {
    User? temp = firebaseAuth.currentUser;
    if(temp != null){
    sl<TBUser>().userId = temp.uid;
    sl<TBUser>().userName = (temp.displayName ?? temp.email)!;
    sl<TBUser>().userMail = temp.email!;
    return temp;
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
          sl<Settings>().isLoggedIn = true;
          User? temp = firebaseAuth.currentUser;
          sl<TBUser>().userId = temp!.uid;
          sl<TBUser>().userName = (temp.displayName ?? temp.email)!;
          sl<TBUser>().userMail = temp.email!;

    } on FirebaseAuthException catch (error) {
      throw AuthError(message: error.message, code: error.code);
    }
  }


  @override
  Future<void> createUser(String name, String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await firebaseAuth.currentUser?.updateDisplayName(name);
      sl<Settings>().isLoggedIn = true;
      User? temp = firebaseAuth.currentUser;
      sl<TBUser>().userId = temp!.uid;
      sl<TBUser>().userName = temp.displayName!;
      sl<TBUser>().userMail = temp.email!;
      // sl<IUserRepository>().createUser(temp.uid, temp.displayName!, temp.email!);
    } on FirebaseAuthException catch (error) {
      throw AuthError(message: error.message, code: error.code);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    }
    on FirebaseAuthException catch (error) {
      throw AuthError(message: error.message, code: error.code);
    }
  }
}
