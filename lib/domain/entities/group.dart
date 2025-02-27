/// A class that represent the [Group]
///
/// This class includes properties for the Groups: [groupId] & [groupName]
/// futhermore it includes methodes for converting fromMap, toJson and tostring
class Group {
  final String groupId;
  final String groupName;

  const Group({
    this.groupId = '',
    required this.groupName,
  });

  /// Factory method to create a [Group] object from a map
  factory Group.fromMap(Map<String, dynamic> json) {
    return Group(
      groupId: json['groupId'],
      groupName: json['groupName'],
    );
  }

  /// Method to convert a [Group] object to a json object
  Map<String, Object?> toJson(){
    return {
      'groupName': groupName,
    };
  }

  /// toString method, returns the [Group] object information
  @override
  String toString(){
    return 'Group($groupId, $groupName)';    
  }
}
