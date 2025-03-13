import 'package:flutter/material.dart';
import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/presentation/views/base/base_view_scaffold.dart';
import 'package:ticketbox/presentation/views/dashboard/dashboard_view_model.dart';
import 'package:ticketbox/presentation/views/dashboard/dashboard_view_widget.dart';
// import 'package:ticketbox/presentation/views/widget/Fab/action_button.dart';
// import 'package:ticketbox/presentation/views/widget/Fab/expandable_fab.dart' show ExpandableFab;

// class DashboardView extends StatefulWidget {
//   const DashboardView({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _DashboardView();
// }
//
// class _DashboardView extends State<DashboardView> {
//   final model = sl<DashboardViewModel>();

  class DashboardView extends StatelessWidget {
  final DashboardViewModel model = sl<DashboardViewModel>();

  DashboardView({super.key});

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
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        onPressed: () async {
          await model.createGroup(context);
        },
        backgroundColor: Colors.white,
        icon: Icon(
          Icons.add,
          size: 32,
        ),
        label: Text("Opret bødekasse"),
      ),
      builder: (context) => DashboardViewWidget(model: model),
    );
  }
}
