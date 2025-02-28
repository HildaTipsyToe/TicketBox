/// A class that represent the [Messages]
///
/// This class includes properties for the Groups: [groupId] & [groupName]
/// furthermore it includes methods for converting fromJson, toJson and toString
/// This class includes properties for the Groups: [messageId], [userId], [groupId], [timeStamp] & [text]
/// futhermore it includes methodes for converting fromMap, toJson and tostring
class Messages {
  final String messageId;
  final String userId;
  final String groupId;
  final String timeStamp;
  final String text;

  Messages({
    this.messageId = '',
    required this.userId,
    required this.groupId,
    required this.timeStamp,
    required this.text,
  });

  /// Factory method to create a [Messages] object from a map
  factory Messages.fromMap(Map<String, dynamic> json) {
    return Messages(
        // messageId: json['messageId'],
        userId: json['userId'],
        groupId: json['groupId'],
        timeStamp: json['timeStamp'],
        text: json['text']);
  }

  /// Method to convert a [Messages] object to a json object
  Map<String, Object?> toJson() {
    return {
      // 'messageId': messageId,
      'userId': userId,
      'groupId': groupId,
      'timeStamp': timeStamp,
      'text': text,
    };
  }

  /// Method for creating a new instance of [TicketType] with updated values, while keeping the existing one unchanged
  Messages copyWith({String? messagesId}) {
    return Messages(
      messageId: messagesId ?? this.messageId,
      userId: userId,
      groupId: groupId,
      timeStamp: timeStamp,
      text: text,
    );
  }

  /// toString method, returns the [Messages] object information
  @override
  String toString() {
    return 'Messages($messageId, $userId, $groupId, $timeStamp, $text)';
  }
}