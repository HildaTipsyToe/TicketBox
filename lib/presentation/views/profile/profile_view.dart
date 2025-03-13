import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/injection_container.dart';
import '../base/base_view_scaffold.dart';
import 'profile_view_model.dart';
import 'profile_view_widget.dart';

class ProfileView extends StatelessWidget {
  final model = sl<ProfileViewModel>();

  ProfileView({super.key});

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
      overrideOnBackPressed: () {context.pop();},
      builder: (context) =>
          ProfileViewWidget(model: model),

    );
  }
}
