/// A class that represent the [BKUser]
///
/// This class includes properties for the users: [userId], [userName] & [userMail],
/// futhermore it includes methodes for converting fromJson, and tostring
class BKUser {
  String userId;
  String userName;
  String userMail;

  BKUser({
    required this.userId,
    required this.userName,
    required this.userMail,
  });

  /// Factory method to create a User object from a map
  factory BKUser.fromMap(Map<String, dynamic> json) {
    return BKUser(
      userId: json['userId'],
      userName: json['userName'],
      userMail: json['userMail'],
    );
  }

  /// toString method, returns the [BKUser] object information
  @override
  String toString() {
    return 'User($userId, $userName, $userMail)';
  }
}
