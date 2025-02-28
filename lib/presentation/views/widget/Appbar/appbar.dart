import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/injection_container.dart';
import '../../../../domain/entities/user.dart';
import '../../../../infrastructure/repository/auth_repository.dart';


AppBar TBAppbar({
  bool? leading,
  bool? action,
  VoidCallback? overrideOnBackPressed,
  required BuildContext context,
}) {
  if (sl<TBUser>().userName.isEmpty) {
    sl<TBUser>().userName = 'X';
  }
  return AppBar(
    toolbarHeight: 75.0,
    title: const Center(
        child: Text(
          "B Ø D E K A S S E",
          style: TextStyle(),
        ),
    ),
    foregroundColor: Colors.white,
    backgroundColor: const Color.fromARGB(255, 0, 61, 108),
    leading: leading == null || leading == true
        ? IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: overrideOnBackPressed ?? () {
              // context.pop();
              context.replace('/dashboard');
            },
          )
        : const SizedBox(width: 30),
    actions: [
      action == null || action == true
          ? TextButton(
              onPressed: () {
                sl<IAuthRepository>().signOut();
                context.go('/login');
              },
              child: Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(25))),
                child: Center(
                  child: Text(
                    sl<TBUser>().userName.substring(0, 1),
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
            )
          : const SizedBox(width: 30),
    ],
  );
}
