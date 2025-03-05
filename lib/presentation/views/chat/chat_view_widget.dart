import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketbox/presentation/views/widget/buttons/icon_button.dart';

import '../../../domain/entities/message.dart';
import '../../shared/constants/app_colors.dart';
import '../widget/process_indicator/circular_progress_indicator.dart';
import 'chat_view_model.dart';

class ChatViewWidget extends StatelessWidget {
  final ChatViewModel model;
  final String groupId;
  final String roleId;

  const ChatViewWidget(
      {super.key,
      required this.model,
      required this.groupId,
      required this.roleId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      height: MediaQuery.of(context).size.height - 70,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: model.getMessageStream(groupId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: TBCircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No messages yet', style: TextStyle(fontSize: 16)),
                  );
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1), // Tilføjer en grå kant
                            borderRadius: BorderRadius.circular(10), // Runde hjørner (valgfrit)
                          ),
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Juster margin
                          child: ListTile(
                            title: Text(message.text),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(message.userName),
                                  Text(message.timeStamp != null ? DateFormat('HH:mm - dd-MM-yyyy').format(message.timeStamp!.toDate()) : '')
                                ]),
                          ),
                        ),
                        if(roleId == '1')
                          Positioned(
                            right: 10,
                            top: 5,
                            child: TBIconButton(
                              icon: Icons.settings,
                              onPressed: () async {
                                model.deleteMessage(message.messageId);
                              },
                              iconSize: 12,
                              size: 20
                            ),
                          )
                      ]
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 100,
            child: TextField(
              textAlign: TextAlign.left,
              controller: model.inputController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.tbBlackTextColor, width: 1)),
                suffixIcon: TBIconButton(
                  onPressed: () {
                    model.addMessage(groupId);
                  },
                  icon: Icons.send,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
