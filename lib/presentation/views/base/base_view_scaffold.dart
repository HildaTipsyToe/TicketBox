import 'package:flutter/material.dart';
import '../widget/Appbar/appbar.dart';

class BaseViewScaffold extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final bool? leading;
  final bool? action;
  final Widget Function(BuildContext context) builder;
  final VoidCallback? overrideOnBackPressed;
  final Widget? floatingActionButton;

  const BaseViewScaffold({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.action,
    required this.builder,
    this.overrideOnBackPressed,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    PreferredSize appbar = PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: tbAppbar(
            context: context,
            leading: leading,
            action: action,
            overrideOnBackPressed: overrideOnBackPressed));
    return Scaffold(
      appBar: appbar,
      //      ? const Drawer(
      //    child: null//RoutingNavigationBar(),
      //  )
      //      : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Builder(
              builder: (context) => builder(context),
            ),
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
