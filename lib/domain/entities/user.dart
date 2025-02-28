/// A class that represent the [TBUser]
///
/// This class includes properties for the users: [userId], [userName] & [userMail],
/// furthermore it includes methods for converting fromMap, and toString
class TBUser {
  String userId;
  String userName;
  String userMail;

  TBUser({
    required this.userId,
    required this.userName,
    required this.userMail,
  });

  /// Factory method to create a User object from a map
  factory TBUser.fromMap(Map<String, dynamic> json) {
    return TBUser(
      userId: json['userId'],
      userName: json['userName'],
      userMail: json['userMail'],
    );
  }

  /// toString method, returns the [TBUser] object information
  @override
  String toString() {
    return 'User($userId, $userName, $userMail)';
  }
}
