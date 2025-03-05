import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/presentation/views/base/base_view_scaffold.dart';
import 'package:ticketbox/presentation/views/fines/fines_view_model.dart';
import 'package:ticketbox/presentation/views/fines/fines_view_widget.dart';

class FinesView extends StatelessWidget {
  final model = sl<FinesViewModel>();
  final String roleId;
  final String groupId;

  FinesView({super.key, required this.groupId, required this.roleId});

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
      builder: (context) =>
          FinesViewWidget(groupId: groupId, roleId: roleId, model: model),
      floatingActionButton: roleId == '1'
          ? FloatingActionButton(
              onPressed: () async {
                await model.addFineDialog(context, groupId);
              },
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
