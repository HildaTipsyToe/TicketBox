

import 'package:cloud_firestore/cloud_firestore.dart';

class ApiDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get userCollection => _firestore.collection('Users');
}