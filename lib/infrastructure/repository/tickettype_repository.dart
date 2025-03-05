import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketbox/domain/entities/tickettype.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';

/// Abstract class that represent the tickettype reposistory
///
/// This interface defines the contract for tickettype-related data operations.
abstract class ITicketTypeRepository {
  Future<List<TicketType>> getTicketTypesByGroupId(String groupId);
  Stream<List<TicketType>> getTicketTypesByGroupIdStream(String groupId);
  Future<void> addTicketType(Map<String, dynamic> ticketTypeData);
  Future<void> updateTicketType(String id, Map<String, dynamic> newData);
  Future<void> deleteTicketType(String id);
}

class TicketTypeRepositoryImpl extends ITicketTypeRepository {
  final ApiDataSource _apiDataSource;

  TicketTypeRepositoryImpl(this._apiDataSource);

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

  @override
  Stream<List<TicketType>> getTicketTypesByGroupIdStream(String groupId) {
    return _apiDataSource.ticketTypeCollection
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => TicketType.fromMap(doc.data() as Map<String, dynamic>)
                .copyWith(ticketTypeId: doc.id))
            .toList());
  }
}

class TicketTypeRepositoryMock extends ITicketTypeRepository {
  @override
  Future<void> addTicketType(Map<String, dynamic> ticketTypeData) async {
    print('Mock - TicketType added');
  }

  @override
  Future<void> deleteTicketType(String id) async {
    print('Mock - TicketType deleted');
  }

  @override
  Future<List<TicketType>> getTicketTypesByGroupId(String groupId) async {
    print('Mock - Get TicketType by groupId');
    List<TicketType> t = [
      TicketType(ticketName: 'ticketName', groupId: groupId)
    ];
    return t;
  }

  @override
  Future<void> updateTicketType(String id, Map<String, dynamic> newData) async {
    print('Mock - TicketType updated');
  }

  @override
  Stream<List<TicketType>> getTicketTypesByGroupIdStream(String groupId) {
    // TODO: implement getTicketTypesByGroupIdStream
    throw UnimplementedError();
  }
}
