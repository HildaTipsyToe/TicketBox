import 'package:cloud_firestore/cloud_firestore.dart';

class ApiDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get groupCollection => _firestore.collection('Groups');
  CollectionReference get ticketTypeCollection => _firestore.collection('TicketTypes');
  CollectionReference get userCollection => _firestore.collection('Users');
  CollectionReference get messageCollection => _firestore.collection('Messages');
  Stream<QuerySnapshot> get messageStream => _firestore.collection('Messages').snapshots();
  CollectionReference get membershipCollection => _firestore.collection('Memberships');
  CollectionReference get postCollection => _firestore.collection('Posts');

}