import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/domain/entities/user.dart';
import 'package:ticketbox/presentation/views/widget/buttons/filled_button.dart';

import '../../../domain/entities/message.dart';
import '../../shared/constants/app_colors.dart';
import '../widget/process_indicator/circular_progress_indicator.dart';
import 'chat_view_model.dart';

class ChatViewWidget extends StatelessWidget {
  final ChatViewModel model;
  final String groupId;
  final String roleId;

  const ChatViewWidget({
    super.key,
    required this.model,
    required this.groupId,
    required this.roleId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      height: MediaQuery.of(context).size.height - 80,
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
                    child:
                        Text('No messages yet', style: TextStyle(fontSize: 16)),
                  );
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: message.userId == sl<TBUser>().userId
                            ? AppColors.tbPrimary
                            : null,
                        border: Border.all(
                            color: Colors.grey,
                            width: 1), // Tilføjer en grå kant
                        borderRadius: BorderRadius.circular(
                            10), // Runde hjørner (valgfrit)
                      ),
                      margin: message.userId == sl<TBUser>().userId
                          ? EdgeInsets.only(
                              left: 35,
                              right: 5,
                              top: 10,
                              bottom: 10,
                            )
                          : EdgeInsets.only(
                              left: 5,
                              right: 35,
                              top: 10,
                              bottom: 10,
                            ), // Juster margin
                      child: Stack(
                        children: [
                          ListTile(
                            textColor: message.userId == sl<TBUser>().userId
                                ? Colors.white
                                : Colors.black,
                            title: Text(message.text),
                            subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    message.userName, style: TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                  Text(message.timeStamp != null
                                      ? DateFormat('HH:mm - dd-MM-yyyy')
                                          .format(message.timeStamp!.toDate())
                                      : '')
                                ]),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: roleId == '1'
                                ? Container(
                                  margin:
                                      EdgeInsets.only(right: 10, top: 2),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () async {
                                        model.deleteMessage(
                                            message.messageId);
                                      },
                                      child:
                                          Icon(Icons.delete, size: 20),
                                    ),
                                  ),
                                )
                                : Container(),
                          ),
                        ],
                      ),
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
                suffixIcon: TBFilledButton(
                  width: 60,
                  height: 40,
                  onPressed: () => model.addMessage(groupId),
                  icon: Icons.send,
                ),
              ),
              onSubmitted: (_) => model.addMessage(groupId),
            ),
          ),
        ],
      ),
    );
  }
}
