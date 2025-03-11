import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/domain/entities/user.dart';
import 'package:ticketbox/presentation/views/members/members_view_model.dart';
import 'package:ticketbox/presentation/views/widget/buttons/icon_button.dart';
import 'package:ticketbox/presentation/views/widget/card/card.dart';
import 'package:ticketbox/presentation/views/widget/process_indicator/circular_progress_indicator.dart';

class MembersViewWidget extends StatelessWidget {
  final MembersViewModel model;
  final String groupId;

  const MembersViewWidget({
    super.key,
    required this.model,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    print(groupId);
    return StreamBuilder(
      stream: model.fetchMember(groupId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool isAdmin = model.isAdminMethod(snapshot.data!);
          bool isAdminOrMoney = model.isAdminOrOther(snapshot.data!);
          return Container(
            margin: const EdgeInsets.only(top: 50),
            width: double.infinity,
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Gruppe medlemmer",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                for (var data in snapshot.data!)
                  Stack(
                    children: [
                      TBCard(
                        onPressed: () {},
                        shadowColor: const Color.fromARGB(255, 161, 160, 160),
                        width: MediaQuery.of(context).size.width / 3 * 2,
                        padding: const EdgeInsets.all(16.0),
                        height: 100,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                data.roleId == 1
                                    ? "Administrator"
                                    : data.roleId == 2
                                        ? "Kasserer"
                                        : data.roleId == 3
                                            ? "Bruger"
                                            : "Inviteret",
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data.userName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        decoration: TextDecoration.underline),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        data.balance.toString(),
                                        style: TextStyle(
                                            fontSize: 21,
                                            color: data.balance > 0
                                                ? Colors.green
                                                : data.balance == 0
                                                    ? Colors.black
                                                    : Colors.red),
                                      ),
                                      const Text(
                                        ",-",
                                        style: TextStyle(
                                          fontSize: 21,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      if (isAdmin || data.userId == sl<TBUser>().userId)
                        Positioned(
                          right: data.userId == sl<TBUser>().userId &&
                                  !isAdminOrMoney
                              ? 0
                              : 100,
                          bottom: 0,
                          child: TBIconButton(
                            icon: Icons.settings,
                            onPressed: () async {
                              await model.editUserDialog(
                                  context, data, isAdmin);
                              if (model.isDeleted) {
                                if (context.mounted) {
                                  context.replace('/dashboard');
                                }
                                model.isDeleted = false;
                              } else {
                                if (context.mounted) {
                                  context.replaceNamed(
                                    'members',
                                    queryParameters: {
                                      'groupId': data.groupId,
                                      'groupName': data.groupName,
                                      'roleId': model.newRole != null
                                          ? model.newRole.toString()
                                          : data.roleId.toString()
                                    },
                                  );
                                }
                              }
                            },
                            iconSize: 32,
                          ),
                        ),
                      if (isAdminOrMoney)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: TBIconButton(
                            icon: Icons.attach_money,
                            onPressed: () async {
                              await model.giveTicket(context, data);
                            },
                            iconSize: 32,
                          ),
                        )
                    ],
                  ),
              ],
            ),
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height - kToolbarHeight - 50,
            child: const Center(
              child: Stack(children: [
                SizedBox(
                    width: 200,
                    height: 200,
                    child: TBCircularProgressIndicator()),
                Positioned(
                  bottom: 100,
                  left: 50,
                  child: Text("LOADING DATA..."),
                )
              ]),
            ),
          );
        }
      },
    );
  }
}
