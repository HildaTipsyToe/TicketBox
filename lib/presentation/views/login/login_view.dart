
import 'package:flutter/material.dart';

import '../../../config/injection_container.dart';
import '../base/base_view_scaffold.dart';
import 'login_view_model.dart';
import 'login_view_widget.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final model = sl<LoginViewModel>();

  @override
  Widget build(BuildContext context) {
    return BaseViewScaffold(
      title: 'BØDEKASSE',
      leading: false,
      action: false,
      builder: (context) =>
            LoginViewWidget(model: model),
    );
  }
}
