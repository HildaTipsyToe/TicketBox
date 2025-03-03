import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../config/injection_container.dart';
import '../../../domain/entities/message.dart';
import '../../../infrastructure/repository/message_repository.dart';
import '../base/base_view_model.dart';

class ChatViewModel extends BaseViewModel {
  TextEditingController inputController = TextEditingController();

  Stream<QuerySnapshot<Object?>> getMessageStream(String groupId) {
    return sl<IMessageRepository>().getMessageStream(groupId);
  }

  addMessage(String groupId) async {
    final input = inputController.text;
    inputController.text = '';

    final newMessage = Message(
        userId: '',
        userName: '',
        groupId: '',
        text: input);

    await sl<IMessageRepository>().addMessage(newMessage);
  }

  deleteMessage(String messageId) async {
    await sl<IMessageRepository>().deleteMessage(messageId);
  }
}
