import 'package:flutter/material.dart';
import 'package:ticketbox/presentation/views/widget/buttons/filled_button.dart';

import '../../shared/constants/app_colors.dart';
import 'profile_view_model.dart';

class ProfileViewWidget extends StatelessWidget {
  final ProfileViewModel model;

  const ProfileViewWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    model.getCurrentUser();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      height: MediaQuery.of(context).size.height - 70,
      child: Column(
        children: [
          Text('Profil',
              style: const TextStyle(fontSize: 30, color: Colors.black)),
          SizedBox(height: 30),
          TextField(
            controller:
                model.nameController, // Sætter teksten i textfielden
            readOnly: true, // Deaktiverer textfielden
            decoration: InputDecoration(
              labelText: 'Navn', // Label teksten
              border: OutlineInputBorder(
                // Tilføjer border omkring textfield
                borderRadius:
                    BorderRadius.circular(8.0), // Rundede hjørner på borderen
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10.0), // Øger størrelsen på textfielden
            ),
            style: TextStyle(fontSize: 18), // Gør tekststørrelsen større
          ),
          SizedBox(height: 20),
          TextField(
            controller:
                model.emailController, // Sætter teksten i textfielden
            readOnly: true, // Deaktiverer textfielden
            decoration: InputDecoration(
              labelText: 'Email', // Label teksten
              border: OutlineInputBorder(
                // Tilføjer border omkring textfield
                borderRadius:
                    BorderRadius.circular(8.0), // Rundede hjørner på borderen
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10.0), // Øger størrelsen på textfielden
            ),
            style: TextStyle(fontSize: 18), // Gør tekststørrelsen større
          ),
          Container(
            alignment: Alignment.center,
            child: TBFilledButton(
              text: 'Rediger profil',
              width: 200,
              onPressed: () {
                  model.editUserDialog(context);
                // setState(() {
                // });
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
                model.deleteUserDialog(context);
              },
              child: const Text(
                'Slet bruger?',
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.tbPrimary,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
