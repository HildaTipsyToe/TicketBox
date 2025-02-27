import 'package:firebase_auth/firebase_auth.dart';

import '../../config/injection_container.dart';

import '../../domain/entities/settings.dart';
import '../../domain/entities/user.dart';

abstract class AuthDataSource {

  Stream<User?> get authStatus;

  Future<User?> getCurrentUser();
  Future<void> signOut();
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUser(String name, String email, String password);
  Future<void> forgotPassword(String email);

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
    sl<BKUser>().userId = temp.uid;
    sl<BKUser>().userName = (temp.displayName ?? temp.email)!;
    sl<BKUser>().userMail = temp.email!;
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
          sl<BKUser>().userId = temp!.uid;
          sl<BKUser>().userName = (temp.displayName ?? temp.email)!;
          sl<BKUser>().userMail = temp.email!;

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
      sl<BKUser>().userId = temp!.uid;
      sl<BKUser>().userName = temp.displayName!;
      sl<BKUser>().userMail = temp.email!;
      sl<IUserRepository>().createUser(temp.uid, temp.displayName!, temp.email!);
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
