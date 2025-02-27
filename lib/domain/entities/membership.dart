/// A class that represent the [Membership]
///
/// This class includes properties for the Memberships: [membershipId], [userId], [userName], [groupId], [groupName], [balance] & [roleId]
/// furthermore it includes methods for converting fromJson, toJson, copyWith and toString
class Membership {
  final String membershipId;
  final String userId;
  final String userName;
  final String groupId;
  final String groupName;
  final int balance;
  final int roleId;

  const Membership({
    this.membershipId = '',
    required this.userId,
    required this.userName,
    required this.groupId,
    required this.groupName,
    required this.balance,
    required this.roleId,
  });

  /// Factory method to create a [Membership] object from a map
  factory Membership.fromMap(Map<String, dynamic> json) {
    return Membership(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      groupId: json['groupId'] ?? '',
      groupName: json['groupName'] ?? '',
      balance: json['balance'] ?? 0,
      roleId: json['roleId'] ?? 0,
    );
  }

  /// Method to convert a [Membership] object to a json object
  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'groupId': groupId,
      'groupName': groupName,
      'balance': balance,
      'roleId': roleId,
    };
  }

  /// Method for creating a new instance of [Membership] with updated values, while keeping the existing one unchanged
  Membership copyWith({String? membershipId}) {
    return Membership(
      membershipId: membershipId ?? this.membershipId,
      userId: userId,
      userName: userName,
      groupId: groupId,
      groupName: groupName,
      balance: balance,
      roleId: roleId,
    );
  }

  /// toString method, returns the [Membership] object information
  @override
  String toString() {
    return 'Membership($membershipId, $userId, $userName, $groupId, $groupName, $balance, $roleId)';
  }
}
