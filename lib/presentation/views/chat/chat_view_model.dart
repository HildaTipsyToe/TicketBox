import 'package:flutter/material.dart';
import 'package:ticketbox/domain/entities/user.dart';

import '../../../config/injection_container.dart';
import '../../../domain/entities/message.dart';
import '../../../infrastructure/repository/message_repository.dart';
import '../base/base_view_model.dart';

class ChatViewModel extends BaseViewModel {
  TextEditingController inputController = TextEditingController();

  Stream<List<Message>> getMessageStream(String groupId) {
    return sl<IMessageRepository>().getMessageStream(groupId);
  }

  addMessage(String groupId) async {
    final input = inputController.text;
    inputController.text = '';

    if (input.trim().isNotEmpty) {
      final newMessage = Message(
          userId: sl<TBUser>().userId,
          userName: sl<TBUser>().userName,
          groupId: groupId,
          text: input);

      await sl<IMessageRepository>().addMessage(newMessage);
    }
  }

  deleteMessage(String messageId) async {
    await sl<IMessageRepository>().deleteMessage(messageId);
  }
}
