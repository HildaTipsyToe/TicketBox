import 'package:cloud_firestore/cloud_firestore.dart';

/// A class that represent the [Message]
///
/// This class includes properties for the Groups: [messageId], [userId], [groupId], [timeStamp] & [text]
/// furthermore it includes methods for converting fromMap, toJson and toString
class Message {
  final String messageId;
  final String userId;
  final String userName;
  final String groupId;
  final Timestamp? timeStamp;
  final String text;

  Message({
    this.messageId = '',
    required this.userId,
    required this.userName,
    required this.groupId,
    this.timeStamp,
    required this.text,
  });

  /// Factory method to create a [Message] object from a map
  factory Message.fromMap(Map<String, dynamic> json) {
    return Message(
        // messageId: json['messageId'],
        userId: json['userId'],
        userName: json['userName'],
        groupId: json['groupId'],
        timeStamp: json['timeStamp'],
        text: json['text']);
  }

  /// Method to convert a [Message] object to a json object
  Map<String, Object?> toJson() {
    return {
      // 'messageId': messageId,
      'userId': userId,
      'userName': userName,
      'groupId': groupId,
      'timeStamp': FieldValue.serverTimestamp(),
      'text': text,
    };
  }

  /// Method for creating a new instance of [Message] with updated values, while keeping the existing one unchanged
  Message copyWith({String? messageId}) {
    return Message(
      messageId: messageId ?? this.messageId,
      userId: userId,
      userName: userName,
      groupId: groupId,
      timeStamp: timeStamp,
      text: text,
    );
  }

  /// toString method, returns the [Message] object information
  @override
  String toString() {
    return 'Message($messageId, $userId, $userName, $groupId, $timeStamp, $text)';
  }
}