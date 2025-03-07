import 'dart:developer';

import 'package:ticketbox/domain/entities/user.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';
import 'package:ticketbox/infrastructure/datasource/auth_datasource.dart';

/// Abstract class that represent the User repository
///
/// This interface defines the contract for user-related data operations.
abstract class IUserRepository {
  Future<TBUser?> getUserByEmail(String email);
  Future<void> createUser(String uid, String name, String email);
  Future<void> updateUserName(String userId, String newUserName);
}

/// Class that represent the user repository
///
/// The [UserRepositoryImpl] have methode for:
/// - create user
/// - retrieving user
/// - update user
class UserRepositoryImpl extends IUserRepository {
  final ApiDataSource _apiDataSource;
final AuthDataSource _authDatasource;

  UserRepositoryImpl(this._apiDataSource, this._authDatasource);

  /// Method for fetching the user by [email]
  /// else return null, with a log statement
  @override
  Future<TBUser?> getUserByEmail(String email) async {
    try {
      var querySnapshot = await _apiDataSource.userCollection
          .where('userMail', isEqualTo: email)
          .limit(1)
          .get();

      // Check if we got a matching document
      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;
        // Parse the collection into a TBUser object
        var userData = userDoc.data() as Map<String, dynamic>;  // Hent data som en Map<String, dynamic>
        return TBUser(
          userId: userDoc.id,
          userName: userData['userName'],  // Brug data() direkte
          userMail: userData['userMail'],  // Brug data() direkte
        );
      }
      //If the search result retrieved nothing
      return null;
    } catch (error) {
      log('Error handling fetching by email: $error');
      return null;
    }
  }

  /// Method for creating a user with [name], [email] and a [uid]
  @override
  Future<void> createUser(String uid, String name, String email) async {
    try {
      Map<String, dynamic> userJson = {
        'userName': name,
        'userMail': email.toLowerCase(),
      };
      return await _apiDataSource.userCollection.doc(uid).set(userJson);
    } catch (error) {
      log('Error handling creating user: $error');
      return;
    }
  }

  /// Method for updating username by with [newUserName] and [userId]
  @override
  Future<void> updateUserName(String userId, String newUserName) async {
    try {
      await _authDatasource.updateDisplayName(newUserName);
      // Update the userName field for the document with the provided userId
      return await _apiDataSource.userCollection.doc(userId).update({
        'userName': newUserName,
      });
    } catch (error) {
      log('Error handling updating user name: $error');
      return;
    }
  }
}

class UserRepositoryMock extends IUserRepository {
  @override
  Future<void> createUser(String uid, String name, String email) async {
    print('Mock - user created');
  }

  @override
  Future<TBUser?> getUserByEmail(String email) async {
    print('Mock - Get user');
    return TBUser(userId: 'userId', userName: 'userName', userMail: 'userMail');
  }

  @override
  Future<void> updateUserName(String userId, String newUserName) async {
    print('Mock - Username updated');
  }
}