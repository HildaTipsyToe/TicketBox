/// A class that represent the [TBSettings]
///
/// This class includes properties for the Settings: [isLoggedIn]
/// furthermore it includes methods for converting fromMap, toJson and toString
class TBSettings{
  bool isLoggedIn;

  TBSettings({
    required this.isLoggedIn,
  });

  /// Factory method to create a [TBSettings] object from a map
  factory TBSettings.fromMap(Map<String, dynamic> json) {
    return TBSettings(
        isLoggedIn: json['isLoggedIn']
    );
  }

  /// Method to convert a [TBSettings] object to a json object
  Map<String, dynamic> toJson() => {
    'isLoggedIn':isLoggedIn
  };

  /// toString method, returns the [TBSettings] object information
  @override
  String toString() {
    return 'Settings($isLoggedIn)';
  }
}
