import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../config/injection_container.dart';
import '../../../domain/entities/message.dart';
import '../../../infrastructure/repository/message_repository.dart';
import '../base/base_view_model.dart';

class ChatViewModel extends BaseViewModel {
  TextEditingController inputController = TextEditingController();

  List<Message> messages = [
    Message(userId: '', groupId: '', timeStamp: Timestamp.fromDate(DateTime.parse('2025-01-01')), text: '', userName: ''),
    Message(userId: '', groupId: '', timeStamp: Timestamp.fromDate(DateTime.parse('2025-01-01')), text: '', userName: '')
  ];

  ChatViewModel();

  Future<bool> getMessagesByGroupId(String groupId) async {
    messages = await sl<IMessageRepository>().getMessagesByGroupId(groupId);
    return true;
  }

  Stream<QuerySnapshot<Object?>> getMessageStream(String groupId) {
    return sl<IMessageRepository>().getMessageStream(groupId);
  }

  addMessage(String groupId) async {
    // Retrieve input from the controllers
    final input = inputController.text;

    // Clear controller for next time dialog is opened
    inputController.text = '';

    // Create a Message object
    final newMessage = Message(
        userId: '',
        userName: '',
        groupId: '',
        text: input);

    // Call the repository to add the TicketType
    await sl<IMessageRepository>().addMessage(newMessage);
  }
}
