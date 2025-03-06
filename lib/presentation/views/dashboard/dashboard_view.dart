import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/presentation/views/base/base_view_scaffold.dart';
import 'package:ticketbox/presentation/views/dashboard/dashboard_view_model.dart';
import 'package:ticketbox/presentation/views/dashboard/dashboard_view_widget.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardView();
}

class _DashboardView extends State<DashboardView> {
  final model = sl<DashboardViewModel>();

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
      leading: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await model.createGroup(context);
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
      builder: (context) => DashboardViewWidget(model: model),
    );
  }
}
