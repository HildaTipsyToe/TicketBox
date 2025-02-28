import 'package:cloud_firestore/cloud_firestore.dart';

class ApiDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get groupCollection => _firestore.collection('Groups');
  CollectionReference get membershipCollection => _firestore.collection('Memberships');
  CollectionReference get ticketTypeCollection => _firestore.collection('TicketTypes');
  CollectionReference get postCollection => _firestore.collection('Posts');
  CollectionReference get userCollection => _firestore.collection('Users');
  CollectionReference get messageCollection => _firestore.collection('Messages');
}