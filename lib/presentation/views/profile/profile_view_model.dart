import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketbox/domain/entities/user.dart';
import 'package:ticketbox/infrastructure/repository/auth_repository.dart';
import 'package:ticketbox/infrastructure/repository/membership_repository.dart';
import 'package:ticketbox/infrastructure/repository/message_repository.dart';
import 'package:ticketbox/infrastructure/repository/user_repository.dart';

import '../../../config/injection_container.dart';
import '../../shared/constants/app_colors.dart';
import '../base/base_view_model.dart';
import '../widget/buttons/filled_button.dart';

class ProfileViewModel extends BaseViewModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  ProfileViewModel () {
    nameController.text = sl<TBUser>().userName;
    emailController.text = sl<TBUser>().userMail;
  }

  void getCurrentUser(){
    nameController.text = sl<TBUser>().userName;
    emailController.text = sl<TBUser>().userMail;
  }


  Future<void> getUser() async {
    User? authUser = await sl<IAuthRepository>().getCurrentUser();
    String email = authUser!.email ?? '';
    TBUser user = (await sl<IUserRepository>().getUserByEmail(email))!;
    sl<TBUser>().userId = user.userId;
    sl<TBUser>().userName = user.userName;
    sl<TBUser>().userMail = user.userMail;
  }


  Future<void> editUserDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 430, width: 400,
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const Text('REDIGER BRUGER',
                    style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.tbBlackTextColor),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        label: Text('Navn'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      controller: nameController,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      enabled: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text('Email'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      controller: emailController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TBFilledButton(
                      onPressed: () async {
                        sl<IUserRepository>().updateUserName(sl<TBUser>().userId, nameController.text);
                        sl<IMembershipRepository>().updateMembershipName(sl<TBUser>().userId, nameController.text);
                        sl<IMessageRepository>().updatePostUserName(sl<TBUser>().userId, nameController.text);
                        context.pop();
                      },
                      text: 'Fortsæt',
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteUserDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: SizedBox(
          width: 200,
          height: 250,
          child: Column(
            children: [
              SizedBox(height: 10),
              Text('Slet bruger', style: TextStyle(fontSize: 25)),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                    "Er du sikker på, du vil slette din bruger?"),
              ),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                TBFilledButton(
                  text: 'Annuller',
                  width: 100,
                  color: Colors.red,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                TBFilledButton(
                  text: 'OK',
                  width: 100,
                  color: Colors.green,
                  onPressed: () async {
                    await sl<IAuthRepository>().deleteUser();
                    if (context.mounted) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}