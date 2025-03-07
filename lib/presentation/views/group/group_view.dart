import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/presentation/views/base/base_view_scaffold.dart';
import 'package:ticketbox/presentation/views/group/group_view_model.dart';
import 'package:ticketbox/presentation/views/group/group_view_widget.dart';

class GroupView extends StatelessWidget {
  final model = sl<GroupViewModel>();
  final String receiverId;
  final String groupId;
  final String groupName;
  final String saldo;
  final String roleId;

  GroupView(
      {super.key,
      required this.receiverId,
      required this.groupId,
      required this.groupName,
      required this.saldo,
      required this.roleId});

  @override
  Widget build(BuildContext context) {
    return BaseViewScaffold(
        title: 'BØDEKASSE',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
        overrideOnBackPressed: () {
          context.pop();
        },
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          icon: Icon(Icons.chat),
          label: Text("åben chat"),
          onPressed: () => context.pushNamed(
            'chat',
            queryParameters: {
              "groupId": groupId,
              "roleId": roleId,
            },
          ),
        ),
        builder: (context) => GroupViewWidget(
            model: model,
            receiverId: receiverId,
            groupId: groupId,
            groupName: groupName,
            saldo: saldo,
            roleId: roleId));
  }
}
