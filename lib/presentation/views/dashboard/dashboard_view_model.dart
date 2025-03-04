import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/domain/entities/group.dart';
import 'package:ticketbox/domain/entities/membership.dart';
import 'package:ticketbox/domain/entities/user.dart';
import 'package:ticketbox/infrastructure/repository/group_repository.dart';
import 'package:ticketbox/infrastructure/repository/membership_repository.dart';
import 'package:ticketbox/presentation/views/base/base_view_model.dart';
import 'package:ticketbox/presentation/views/widget/buttons/filled_button.dart';

class DashboardViewModel extends BaseViewModel {
  DashboardViewModel();

  Stream<List<Membership>> fetchGroups() {
    List<Membership> tempMemberships;
    try {
      return sl<IMembershipRepository>()
          .getGroupsByUserIDStream(sl<TBUser>().userId);

      // sl<IMembershipRepository>()
      //     .test(sl<TBUser>().userId);
      // return tempMemberships;
    } catch (error) {
      print("FAILED!: $error");
      Exception('ERROR IN THE MAKING!');
      return Stream.value([]);
    }
  }

  Future<void> leaveGroup(Membership data) async {
    await sl<IMembershipRepository>().deleteMembership(data);
  }

  Future<void> updateRole(String id, Membership newData) async {
    await sl<IMembershipRepository>().updateMembership(id, newData.toJson());
  }

  Future<void> createGroup(BuildContext context) async {
    TextEditingController nameController = TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
                width: 400,
                height: 400,
                child: Column(
                  children: [
                    Center(
                        child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      child: const Text(
                        "Opret gruppe",
                        style: TextStyle(fontSize: 25),
                      ),
                    )),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text(
                              'Gruppe navn',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          controller: nameController,
                        ),
                      ),
                    ),
                    TBFilledButton(
                      onPressed: () async {
                        if (nameController.text.isNotEmpty) {
                          try {
                            await sl<IGroupRepository>().addGroup(
                                Group(groupName: nameController.text).toJson());
                          } on Exception {
                            Exception('FAILED TO CREATE GROUP!');
                          }
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      text: "Opret",
                    ),
                  ],
                )),
          );
        });
  }

  Future<void> deleteGroup(BuildContext context, String id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 200,
            height: 200,
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 25),
                    child: const Text(
                      'Slet bødekasse',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                TBFilledButton(
                  onPressed: () async {
                    try {
                      sl<IGroupRepository>().deleteGroup(id);
                      Navigator.pop(context);
                    } on Exception {
                      Exception('DELETE GROUP FAILED');
                      Navigator.pop(context);
                    }
                  },
                  text: 'Fjern bødekasse',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
