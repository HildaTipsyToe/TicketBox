import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketbox/domain/entities/tickettype.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';

/// Abstract class that represent the tickettype reposistory
///
/// This interface defines the contract for tickettype-related data operations.
abstract class ITicketTypeRepository {
  Future<List<TicketType>> getTicketTypesByGroupId(String groupId);
  Future<void> addTicketType(Map<String, dynamic> ticketTypeData);
  Future<void> updateTicketType(String id, Map<String, dynamic> newData);
  Future<void> deleteTicketType(String id);
}

class TickettypeRepository extends ITicketTypeRepository {
  final ApiDataSource _apiDataSource;

  TickettypeRepository(this._apiDataSource);

  @override
  Future<void> addTicketType(Map<String, dynamic> ticketTypeData) async {
    try {
      await _apiDataSource.ticketTypeCollection.add(ticketTypeData);
    } catch (error) {
      log('Error handeling adding a ticket type: $error');
      return Future.error('Error handeling adding a tickettype: $error');
    }
  }

  @override
  Future<void> deleteTicketType(String id) async {
    try {
      await _apiDataSource.ticketTypeCollection.doc(id).delete();
    } catch (error) {
      log('Error handeling the deletion of ticket type: $error');
      return Future.error(
          'Error handeling the deletion of ticket type: $error');
    }
  }

  @override
  Future<List<TicketType>> getTicketTypesByGroupId(String groupId) async {
    try {
      QuerySnapshot querySnapshot = await _apiDataSource.ticketTypeCollection
          .where('groupId', isEqualTo: groupId)
          .get();

      List<TicketType> tickets = querySnapshot.docs
          .map((doc) => TicketType.fromMap(doc.data() as Map<String, dynamic>)
              .copyWith(ticketTypeId: doc.id))
          .toList();
      return tickets;
    } catch (error) {
      log('Error handeling retreving the ticket types by group id: $error');
      return Future.error(
          'Error handeling retreving the ticket types by group id: $error');
    }
  }

  @override
  Future<void> updateTicketType(String id, Map<String, dynamic> newData) async {
    try {
      await _apiDataSource.ticketTypeCollection.doc(id).update(newData);
    } catch (error) {
      log('Error handeling updating the ticket type: $error');
      return Future.error('Error handeling updating the ticket type: $error');
    }
  }
}
