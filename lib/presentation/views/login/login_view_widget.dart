import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/injection_container.dart';
import '../../../domain/entities/settings.dart';
import '../../../domain/entities/user.dart';
import '../../shared/constants/app_colors.dart';
import '../widget/buttons/filled_button.dart';
import 'login_view_model.dart';

class LoginViewWidget extends StatelessWidget {
  final LoginViewModel model;

  const LoginViewWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return sl<TBSettings>().isLoggedIn == true
        ? Column(
            children: [
              SizedBox(height: 20),
              Text('Du er logget ind som ${sl<TBUser>().userName}'),
              TBFilledButton(
                  onPressed: () {
                    context.goNamed('dashboard');
                  },
                  text: 'OK')
            ],
          )
        : Form(
            key: model.signInFormKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text('Email'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      controller: model.emailController,
                      onFieldSubmitted: (value) {
                        model.passwordFocusNode.requestFocus();
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      focusNode: model.passwordFocusNode,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        label: Text('Password'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      controller: model.passwordController,
                      onFieldSubmitted: (value) {
                        model.loginEmail(context);
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    height: 26.0,
                    width: MediaQuery.of(context).size.width - 100,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0.0)),
                      onPressed: () {
                        model.forgotPasswordDialog(context);
                      },
                      child: const Text(
                        'Glemt password?',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.tbPrimary,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  TBFilledButton(
                    onPressed: () => model.loginEmail(context),
                    text: 'Fortsæt',
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Text(
                        'Opret profil',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(decoration: TextDecoration.underline),
                      ),
                      onPressed: () {
                        model.createUserDialog(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
