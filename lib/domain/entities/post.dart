import 'package:intl/intl.dart';

/// A class that represent the [Post]
///
/// This class includes properties for the Posts: [postId], [adminId], [adminName], [groupId], [dateIssued], [price], [receiverId], [receiverName], [ticketTypeId] & [ticketTypeName],
/// furthermore it includes methods for converting fromMap, toJson, copyWith and toString
class Post {
  final String postId;
  final String adminId;
  final String adminName;
  final String groupId;
  final String? dateIssued;
  final int price;
  final String receiverId;
  final String receiverName;
  final String ticketTypeId;
  final String ticketTypeName;

  Post({
    this.postId = '',
    required this.adminId,
    required this.adminName,
    required this.groupId,
    String? dateIssued,
    required this.price,
    required this.receiverId,
    required this.receiverName,
    required this.ticketTypeId,
    required this.ticketTypeName,
  }) : dateIssued = dateIssued ?? DateFormat('dd MM yyy').format(DateTime.now()).toString();

  /// Factory method to create a [Post] object from a map
  factory Post.fromMap(Map<String, dynamic> json) {
    return Post(
      adminId: json['admin'] ?? '',
      adminName: json['adminName'] ?? '',
      dateIssued: json['dateUssued'] ?? '',
      groupId: json['groupId'] ?? '',
      price: json['price'] ?? '',
      receiverId: json['receiverId'] ?? '',
      receiverName: json['receiverName'] ?? '',
      ticketTypeId: json['ticketTypeId'] ?? '',
      ticketTypeName: json['ticketTypeName'] ?? '',
    );
  }

  /// Method to convert a [Post] object to a json object
  Map<String, Object?> toJson() {
    return {
      "adminId": adminId,
      "adminName": adminName,
      "groupId": groupId,
      "dateIssued": dateIssued,
      "price": price,
      "receiverId": receiverId,
      "receiverName": receiverName,
      "ticketTypeId": ticketTypeId,
      "ticketTypeName": ticketTypeName,
    };
  }

  /// Method for creating a new instance of [Post] with updated values, while keeping the existing one unchanged
  Post copyWith({String? postId}) {
    return Post(
      postId: postId ?? this.postId,
      adminId: adminId,
      adminName: adminName,
      dateIssued: dateIssued,
      groupId: groupId,
      price: price,
      receiverId: receiverId,
      receiverName: receiverName,
      ticketTypeId: ticketTypeId,
      ticketTypeName: ticketTypeName,
    );
  }

  /// toString method, returns the [Post] object information
  @override
  String toString(){
    return 'Post($postId, $adminId, $adminName, $dateIssued, $groupId, $price, $receiverId, $receiverName, $ticketTypeId, $ticketTypeName)';
  }
}
