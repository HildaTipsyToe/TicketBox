import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketbox/domain/entities/membership.dart';
import 'package:ticketbox/presentation/views/dashboard/dashboard_view_model.dart';
import 'package:ticketbox/presentation/views/widget/Fab/action_button.dart';
import 'package:ticketbox/presentation/views/widget/Fab/expandable_fab.dart';
import 'package:ticketbox/presentation/views/widget/card/card.dart';
import 'package:ticketbox/presentation/views/widget/process_indicator/circular_progress_indicator.dart';

class DashboardViewWidget extends StatelessWidget {
  final DashboardViewModel model;

  const DashboardViewWidget({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(top: 50),
      height: MediaQuery.of(context).size.height - 75, //appbar height
      width: double.infinity,
      child: StreamBuilder(
        stream: model.fetchGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return TBCircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Du er ikke medlem af nogen gruppe endnud!'),
            );
          }
          final group = snapshot.data;
          return ListView.builder(
            padding: EdgeInsets.only(bottom: 100),
            itemCount: group!.length,
            itemBuilder: (BuildContext context, int index) {
              final data = group[index];
              return SizedBox(
                width: double.infinity,
                child: Center(
                  child: Stack(
                    children: [
                      TBCard(
                        onPressed: () => context.pushNamed(
                          "group",
                          queryParameters: {
                            'receiverId': data.userId,
                            'groupId': data.groupId,
                            'groupName': data.groupName,
                            'saldo': data.balance.toString(),
                            'roleId': data.roleId.toString(),
                          },
                        ),
                        shadowColor: const Color.fromARGB(255, 161, 160, 160),
                        width: width / 3 * 2,
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
                                    data.groupName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        decoration: TextDecoration.underline),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${data.balance}",
                                        style: TextStyle(
                                            fontSize: 24,
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
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: SizedBox(
                          width: 300, // Adjust based on your layout needs
                          height: 100, // Adjust based on your layout needs
                          child: ExpandableFab(
                            distance: 50,
                            children: [
                              if (data.roleId == 1)
                                ActionButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async => await model
                                      .deleteGroup(context, data.groupId),
                                ),
                              if (data.roleId != 4)
                                ActionButton(
                                  icon: Icon(Icons.people_outline),
                                  onPressed: () => context.pushNamed(
                                    'members',
                                    queryParameters: {
                                      'groupId': data.groupId,
                                      'groupName': data.groupName,
                                      'roleId': data.roleId.toString()
                                    },
                                  ),
                                ),
                              if (data.roleId == 4)
                                ActionButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      print("hello");
                                      await model.leaveGroup(data);
                                    }),
                              if (data.roleId == 4)
                                ActionButton(
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  onPressed: () async {
                                    Membership updatedMembership = Membership(
                                      userId: data.userId,
                                      userName: data.userName,
                                      groupId: data.groupId,
                                      groupName: data.groupName,
                                      balance: data.balance,
                                      roleId: 3,
                                    );
                                    await model.updateRole(
                                        data.membershipId, updatedMembership);
                                  },
                                )
                            ],
                          ),
                        ),
                      ),
                      // if (data.roleId == 1)
                      //   Positioned(
                      //     right: 100,
                      //     bottom: 0,
                      //     child: TBIconButton(
                      //       icon: Icons.delete,
                      //       onPressed: () async {
                      //         await model.deleteGroup(context, data.groupId);
                      //       },
                      //       iconSize: 32,
                      //     ),
                      //   ),
                      // if (data.roleId != 4)
                      //   Positioned(
                      //     right: 0,
                      //     bottom: 0,
                      //     child: TBIconButton(
                      //       icon: Icons.people_outline,
                      //       onPressed: () {
                      //         // sl<MembersViewModel>().newRole = data.roleId;
                      //         context.pushNamed(
                      //           'members',
                      //           queryParameters: {
                      //             'groupId': data.groupId,
                      //             'groupName': data.groupName,
                      //             'roleId': data.roleId.toString()
                      //           },
                      //         );
                      //       },
                      //       iconSize: 32,
                      //     ),
                      //   ),
                      // if (data.roleId == 4)
                      //   Positioned(
                      //     right: 0,
                      //     bottom: 0,
                      //     child: TBIconButton(
                      //       icon: Icons.close,
                      //       color: Colors.red,
                      //       onPressed: () async {
                      //         await model.leaveGroup(data);
                      //       },
                      //       iconSize: 32,
                      //     ),
                      //   ),
                      // if (data.roleId == 4)
                      //   Positioned(
                      //     right: 100,
                      //     bottom: 0,
                      //     child: TBIconButton(
                      //       icon: Icons.check,
                      //       color: Colors.green,
                      //       onPressed: () async {
                      //         Membership updatedMembership = Membership(
                      //           userId: data.userId,
                      //           userName: data.userName,
                      //           groupId: data.groupId,
                      //           groupName: data.groupName,
                      //           balance: data.balance,
                      //           roleId: 3,
                      //         );
                      //         await model.updateRole(
                      //             data.membershipId, updatedMembership);
                      //       },
                      //       iconSize: 32,
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
