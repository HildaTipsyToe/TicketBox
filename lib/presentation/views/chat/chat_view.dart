import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/injection_container.dart';
import '../base/base_view_scaffold.dart';
import 'chat_view_model.dart';
import 'chat_view_widget.dart';

class ChatView extends StatelessWidget {
  final String groupId;
  final String roleId;
  final ChatViewModel model = sl<ChatViewModel>();

  ChatView({super.key, required this.groupId, required this.roleId});

  @override
  Widget build(BuildContext context) {
    return BaseViewScaffold(
      title: 'BØDEKASSE',
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.black
          ),
          onPressed: () {},
        ),
      ],
      overrideOnBackPressed: () => context.pop(),
      builder: (context) =>
            ChatViewWidget(model: model, groupId: groupId, roleId: roleId),

    );
  }
}
