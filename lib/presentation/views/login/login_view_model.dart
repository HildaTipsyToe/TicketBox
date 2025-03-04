import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/injection_container.dart';
import '../../../infrastructure/repository/auth_repository.dart';
import '../../shared/constants/app_colors.dart';
import '../base/base_view_model.dart';
import '../widget/buttons/filled_button.dart';


enum SignInAuthError {
  noError,
  invalidCredentials,
  wrongPassword,
  tooManyRequest,
  userNotFound,
  invalidEmail,
  unknownError
}

enum CreateUserAuthError {
  noError,
  emailInUse,
  invalidEmail,
  weakPassword,
  unknownError
}

enum ResetPasswordAuthError {
  noError,
  invalidEmail,
  tooManyRequest,
  userNotFound,
  unknownError,
  success
}

extension CreateUserAuthErrorExtension on CreateUserAuthError {
  String get message {
    switch (this) {
      case CreateUserAuthError.noError:
        return '';
      case CreateUserAuthError.unknownError:
        return 'Ukendt fejl - prøv igen';
      case CreateUserAuthError.invalidEmail:
        return 'Email er ikke gyldig';
      case CreateUserAuthError.emailInUse:
        return 'Denne email er allerede i brug';
      case CreateUserAuthError.weakPassword:
        return 'Stærkere password - mindst 6 tegn';
    }
  }
}

extension SignInAuthErrorExtension on SignInAuthError {
  String get message {
    switch (this) {
      case SignInAuthError.noError:
        return '';
      case SignInAuthError.wrongPassword:
        return 'Password er forkert';
      case SignInAuthError.tooManyRequest:
        return 'For mange forsøg - prøv igen senere';
      case SignInAuthError.userNotFound:
        return 'Bruger findes ikke...';
      case SignInAuthError.unknownError:
        return 'Ukendt fejl - prøv igen';
      case SignInAuthError.invalidEmail:
        return 'Email er ikke gyldig';
      case SignInAuthError.invalidCredentials:
        return 'Brugernavn eller password er forkert';
    }
  }
}

extension ResetPasswordAuthErrorExtention on ResetPasswordAuthError {
  String get message {
    switch (this) {
      case ResetPasswordAuthError.noError:
        return '';
      case ResetPasswordAuthError.invalidEmail:
        return 'Ugyldig e-mail';
      case ResetPasswordAuthError.tooManyRequest:
        return 'For mange forsøg - prøv igen senere';
      case ResetPasswordAuthError.userNotFound:
        return 'Denne e-mail findes ikke i vores database';
      case ResetPasswordAuthError.unknownError:
        return 'Ukendt fejl - prøv igen';
      case ResetPasswordAuthError.success:
        return 'Vi har nu sendt dig et link, hvor du kan ændre dit password.';
    }
  }
}

class LoginViewModel extends BaseViewModel {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController createEmailController = TextEditingController();
  final TextEditingController createPasswordController = TextEditingController();

  final signInFormKey = GlobalKey<FormState>();
  final createUserFormKey = GlobalKey<FormState>();

  LoginViewModel(){
    passwordController.text = "Test1234";
    emailController.text = 'j@j.com';
  }

  SignInAuthError signInAuthError = SignInAuthError.noError;
  ResetPasswordAuthError resetPasswordAuthError = ResetPasswordAuthError.noError;
  CreateUserAuthError createUserAuthError = CreateUserAuthError.noError;

  Future<void> createUser(BuildContext context) async {
    if (!busy) {
      setBusy(true);
      try{
        await sl<IAuthRepository>().createUser(nameController.text.trim(), createEmailController.text.trim(), createPasswordController.text.trim());
        setBusy(false);
        createUserAuthError = CreateUserAuthError.noError;
        setBusy(false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green,content: Text('Bruger oprettet - log ind med den nye bruger')));
      } on AuthError catch (error) {
        if (error.code == 'email-already-in-use') {
          createUserAuthError = CreateUserAuthError.emailInUse;
        } else if (error.code == 'invalid-email') {
          createUserAuthError = CreateUserAuthError.invalidEmail;
        } else if (error.code == 'weak-password') {
          createUserAuthError = CreateUserAuthError.weakPassword;
        } else {
          createUserAuthError = CreateUserAuthError.unknownError;
        }

        setBusy(false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text('Fejl - ${createUserAuthError.message}')));
      }
    }
  }

  loginEmail(BuildContext context) async {
    if (!signInFormKey.currentState!.validate()) return;
    if (!busy) {
      setBusy(true);
      try {
        await signInWithEmailCredentials(context);
        signInAuthError = SignInAuthError.noError;
        emailController.text = '';
        passwordController.text = '';
        // context.pushNamed(
        //   "chat",
        //   queryParameters: {
        //     'groupId': '',
        //     'roleId': '',
        //   },
        // );
        context.pushNamed('dashboard');
        setBusy(false);
      } on AuthError catch (error) {
        print('error.code: ${error.code}');
        if (error.code == 'invalid-credential') {
          signInAuthError = SignInAuthError.invalidCredentials;
        } else if (error.code == 'wrong-password') {
          signInAuthError = SignInAuthError.wrongPassword;
        } else if (error.code == 'too-many-requests') {
          signInAuthError = SignInAuthError.tooManyRequest;
        } else if (error.code == 'user-not-found' ||
            error.code == 'user-disabled') {
          signInAuthError = SignInAuthError.userNotFound;
        } else if (error.code == 'invalid-email') {
          signInAuthError = SignInAuthError.invalidEmail;
        } else {
          signInAuthError = SignInAuthError.unknownError;
        }
        setBusy(false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text('Fejl - ${signInAuthError.message}')));
      }
    }
  }

  Future<void> signInWithEmailCredentials(BuildContext context) async {
    try {
      await sl<IAuthRepository>().signInWithEmailAndPassword(
          emailController.text.trim(), passwordController.text);
    } on AuthError catch (error) {
      passwordController.text = '';
      throw AuthError(message: error.message, code: error.code);
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    if (!busy) {
      setBusy(true);
      try {
        await sl<IAuthRepository>().forgotPassword(createEmailController.text);
        resetPasswordAuthError = ResetPasswordAuthError.success;
        setBusy(false);
      } on AuthError catch (error) {
        setBusy(false);
        print(error.code);
        if (error.code == 'invalid-email') {
          resetPasswordAuthError = ResetPasswordAuthError.invalidEmail;
        } else if (error.code == 'user-not-found') {
          resetPasswordAuthError = ResetPasswordAuthError.userNotFound;
        } else if (error.code == 'too-many-requests') {
          resetPasswordAuthError = ResetPasswordAuthError.tooManyRequest;
        } else {
          resetPasswordAuthError = ResetPasswordAuthError.unknownError;
        }
      }
      setBusy(false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(resetPasswordAuthError.message)));
    }
  }

  validateEmailFront(String value) {
    if (value.isEmpty) {
      return 'Indtast email';
    }
    if (!value.contains('@') ||
        !value.split('@')[1].contains('.') ||
        value.split('.').last.length < 2) {
      return 'Ugyldig e-mail';
    } else {
      return null;
    }
  }

  String? validatePasswordFront(String? value) {
    if (value == null || value.isEmpty) {
      return 'Indtast adgangskode';
    }
    if (value.length < 6) {
      return 'Adgangskoden skal mindst bestå af 6 tegn';
    } else {
      return null;
    }
  }


  Future<void> createUserDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 430, width: 400,
            child: Form(
              key: createUserFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const Text('OPRET BRUGER',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.tbBlackTextColor),
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
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text('Email'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      controller: createEmailController,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        label: Text('Password'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      controller: createPasswordController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TBFilledButton(
                      onPressed: () async {
                        await createUser(context);
                        if (createUserAuthError == CreateUserAuthError.noError) {
                          createEmailController.text = '';
                          createPasswordController.text = '';
                          nameController.text = '';
                          sl<IAuthRepository>().signOut();
                          context.pop();
                        } else {
                          context.pop();
                        }
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

  Future<void> forgotPasswordDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 230, width: 400,
            child: Form(
              key: createUserFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const Text('NULSTIL PASSWORD', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.tbBlackTextColor),),

                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text('Email'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      controller: createEmailController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TBFilledButton(
                      onPressed: () async {
                        await forgotPassword(context);
                        createEmailController.text = '';
                        context.pop();
                      },
                      text: 'Fortsæt',
                    ),
                  )
                ],
              ),
            ),
          ),);
      },
    );
  }
}

