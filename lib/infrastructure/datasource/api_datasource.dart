import 'package:cloud_firestore/cloud_firestore.dart';

/// Class that represent the Api Datasource
///
/// Connects to the different tables of the firebase database.
class ApiDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get groupCollection => _firestore.collection('Groups');
  CollectionReference get membershipCollection => _firestore.collection('Memberships');
  CollectionReference get postCollection => _firestore.collection('Posts');
  CollectionReference get ticketTypeCollection => _firestore.collection('TicketTypes');
  CollectionReference get userCollection => _firestore.collection('Users');
  CollectionReference get messageCollection => _firestore.collection('Messages');
}