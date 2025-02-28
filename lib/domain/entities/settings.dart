/// A class that represent the [Settings]
///
/// This class includes properties for the Settings: [isLoggedIn]
/// furthermore it includes methods for converting fromMap, toJson and toString
class Settings{
  bool isLoggedIn;

  Settings({
    required this.isLoggedIn,
  });

  /// Factory method to create a [Settings] object from a map
  factory Settings.fromMap(Map<String, dynamic> json) {
    return Settings(
        isLoggedIn: json['isLoggedIn']
    );
  }

  /// Method to convert a [Settings] object to a json object
  Map<String, dynamic> toJson() => {
    'isLoggedIn':isLoggedIn
  };

  /// toString method, returns the [Settings] object information
  @override
  String toString() {
    return 'Settings($isLoggedIn)';
  }
}
