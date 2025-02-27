/// A class that represent the [TicketType]
///
/// This class includes properties for the TicketTypes: [ticketTypeId], [ticketName], [groupId] & [price],
/// futhermore it includes methodes for converting fromMap, toJson, copyWith and tostring
class TicketType {
  final String ticketTypeId;
  final String ticketName;
  final String groupId;
  final int? price;

  const TicketType({
    this.ticketTypeId = '',
    required this.ticketName,
    required this.groupId,
    this.price
    });

  /// Factory method to create a [TicketType] object from a map
  factory TicketType.fromMap(Map<String, dynamic> json) {
    return TicketType(
      ticketName: json['ticketName'] ?? '',
      groupId: json['groupId'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  /// Method to convert a [TicketType] object to a json object
  Map<String, Object?> toJson() {
    return {
      "ticketName": ticketName,
      "groupId": groupId,
      "price": price,
    };
  }

  /// Method for creating a new instance of [TicketType] with updated values, while keeping the existing one unchanged
  TicketType copyWith({String? ticketTypeId}) {
    return TicketType(
      ticketTypeId: ticketTypeId ?? this.ticketTypeId,
      ticketName: ticketName,
      groupId: groupId,
      price: price,
    );
  }

  /// toString method, returns the [TicketType] object information
  @override
  String toString() {
    return 'TicketType($ticketTypeId, $ticketName, $groupId, $price)';
  }
}
