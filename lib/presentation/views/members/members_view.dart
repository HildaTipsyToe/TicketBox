import 'package:flutter/material.dart';
import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/presentation/views/base/base_view_scaffold.dart';
import 'package:ticketbox/presentation/views/members/members_view_model.dart';
import 'package:ticketbox/presentation/views/members/members_view_widget.dart';

class MembersView extends StatelessWidget {
  final model = sl<MembersViewModel>();
  final String groupId;
  final String groupName;
  final String roleId;

  MembersView({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.roleId,
  });
  
  @override
  Widget build(BuildContext context) {
   return BaseViewScaffold(
      title: 'BØDEKASSE',
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ],
      // overrideOnBackPressed: () {
      //   context.go("/");
      // },
      builder: (context) => MembersViewWidget(model: model, groupId: groupId, roleId: roleId,),
      floatingActionButton: roleId == '1'
          ? FloatingActionButton.extended(
              onPressed: () async {
                await model.addMember(context, groupName, groupId);
              },
              backgroundColor: Colors.white,
              label: Text('Tilføj medlem'),
              icon: const Icon(Icons.add),
            )
          : null // No FAB if roleId is not 1,
    );
  }
}
