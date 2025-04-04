import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/domain/entities/membership.dart';
import 'package:ticketbox/domain/entities/post.dart';
import 'package:ticketbox/domain/entities/tickettype.dart';
import 'package:ticketbox/domain/entities/user.dart';
import 'package:ticketbox/infrastructure/repository/membership_repository.dart';
import 'package:ticketbox/infrastructure/repository/post_repository.dart';
import 'package:ticketbox/infrastructure/repository/tickettype_repository.dart';
import 'package:ticketbox/infrastructure/repository/user_repository.dart';
import 'package:ticketbox/presentation/views/base/base_view_model.dart';
import 'package:ticketbox/presentation/views/group/group_view_model.dart';
import 'package:ticketbox/presentation/views/widget/buttons/filled_button.dart';
import 'package:ticketbox/presentation/views/widget/dropdowns/dropdown_button.dart';

import '../widget/process_indicator/circular_progress_indicator.dart';

class MembersViewModel extends BaseViewModel {
  bool isDeleted = false;
  int? newRole;

  Future<void> addMember(
      BuildContext context, String groupName, String groupId) {
    TextEditingController emailController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
            width: 200,
            height: 250,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Inviter medlem",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        infoDialog(context);
                      },
                      icon: Icon(Icons.info_rounded),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      controller: emailController,
                    ),
                  ),
                ),
                TBFilledButton(
                  onPressed: () async {
                    TBUser? temp = await sl<IUserRepository>()
                        .getUserByEmail(emailController.text.toLowerCase());
                    if (emailController.text.isNotEmpty && temp != null) {
                      await sl<IMembershipRepository>()
                          .addMembership(Membership(
                        userId: temp.userId,
                        userName: temp.userName,
                        groupId: groupId,
                        groupName: groupName,
                        balance: 0,
                        roleId: 4,
                      ));
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Brugeren findes ikke')));
                      }
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  text: "Send invitation",
                ),
              ],
            )),
      ),
    );
  }

  Future<void> editUserDialog(
      BuildContext context, Membership member, bool isAdmin) {
    String role = member.roleId.toString();
    return showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: SizedBox(
          width: 200,
          height: !isAdmin || member.roleId == 4 ? 200 : 400,
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 25),
                  child: const Text(
                    "Rediger medlem",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              !isAdmin || member.roleId == 4
                  ? Container()
                  : TBDropdownButton<String>(
                      data: ["Administrator", "Kasserer", "Medlem"],
                      callback: (val) {
                        role = val;
                      },
                      itemsLayout: (dynamic value) {
                        return Text(value);
                      },
                      hint: ({value}) => Center(
                        child: Text(
                          "Vælg rolle",
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
              !isAdmin || member.roleId == 4
                  ? Container()
                  : TBFilledButton(
                      onPressed: () async {
                        // Determine the new role ID based on the selected string
                        String newRoleId = "3"; // Default to 'Medlem'
                        if (role == "Administrator") {
                          newRoleId = "1";
                        }
                        if (role == "Kasserer") {
                          newRoleId = "2";
                        }
                        if (role == "Medlem") {
                          newRoleId = "3";
                        }
                        // Create the updated membership object
                        Membership updatedMembership = Membership(
                          userId: member.userId,
                          userName: member.userName,
                          groupId: member.groupId,
                          groupName: member.groupName,
                          balance: member.balance,
                          roleId: int.parse(newRoleId),
                        );

                        try {
                          // Check if the role can be updated
                          bool canUpdate = await sl<IMembershipRepository>()
                              .canUpdateMembershipRole(member);

                          if (canUpdate) {
                            // If allowed, proceed with updating the membership
                            await sl<IMembershipRepository>().updateMembership(
                              member.membershipId,
                              updatedMembership.toJson(),
                            );

                            // If the current user is updating their own role, update the local variable
                            if (sl<TBUser>().userId == member.userId) {
                              newRole = int.parse(newRoleId);
                            }

                            // Close the dialog after success
                            // Navigator.pop(context);
                          } else if (newRoleId != '1') {
                            // Navigator.pop(context);
                            // Show a SnackBar if update is not allowed
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.amber,
                                  content: Text(
                                    "Der skal mindst være én administrator",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  duration: Duration(seconds: 10),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          print("Update membership failed: $e");
                          // Navigator.pop(context); // Close the dialog in case of failure
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      text: "Gem ændring",
                    ),
              TBFilledButton(
                onPressed: () async {
                  // Check if the membership can be deleted
                  Map<String, dynamic> deletionCheck =
                      await sl<IMembershipRepository>()
                          .canDeleteMembership(member);
                  print(deletionCheck);
                  bool canDelete = deletionCheck['canDelete'];
                  String message = deletionCheck['message'];

                  print(deletionCheck['canDelete']);
                  if (canDelete) {
                    // Delete the membership
                    await sl<IMembershipRepository>().deleteMembership(member);

                    // If the group was deleted, navigate back to the dashboard
                    if (sl<TBUser>().userId == member.userId) {
                      if (context.mounted) {
                        context.pop();
                      }
                      isDeleted = true;
                    } else {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  } else {
                    if (context.mounted) {
                      Navigator.pop(context);
                      // Show a message if the membership cannot be deleted
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            message,
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                },
                text: member.userId == sl<TBUser>().userId
                    ? "Forlad gruppe"
                    : "Fjern medlem",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> infoDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: SizedBox(
          width: 200,
          height: 300,
          child: Column(
            children: [
              SizedBox(height: 10),
              Text('INFO', style: TextStyle(fontSize: 25)),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                    "Hvis du vil tilføje medlemmer til gruppen, skal de først oprettes i app'en. Derefter kan du tilføje dem til gruppen ved at indtaste deres e-mail her."),
              ),
              SizedBox(height: 10),
              TBFilledButton(
                text: 'OK',
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<List<Membership>> fetchMember(String groupId) {
    Stream<List<Membership>> tempMembers =
        sl<IMembershipRepository>().getMembershipsByGroupIdStream(groupId);
    return tempMembers;
  }

  bool isAdminOrOther(List<Membership> members) {
    if (members.any((x) => x.roleId == 1 && x.userId == sl<TBUser>().userId) ||
        members.any((x) => x.roleId == 2 && x.userId == sl<TBUser>().userId)) {
      return true;
    }
    return false;
  }

  bool isAdminMethod(List<Membership> members) {
    if (members.any((x) => x.roleId == 1 && x.userId == sl<TBUser>().userId)) {
      return true;
    }
    return false;
  }

  Future<void> deletePost(Post post) async {
    await sl<IPostRepository>().deletePost(post);
  }

  Future<DateTime> _selectDate(
      BuildContext context, DateTime selectedDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      return picked;
    }
    return selectedDate;
  }

  Future<void> giveTicket(BuildContext context, Membership data) async {
    List<String> month = [
      'jan.',
      'feb.',
      'mar.',
      'apr.',
      'maj.',
      'jun.',
      'jul.',
      'aug.',
      'sep.',
      'okt.',
      'nov.',
      'dec.',
    ];
    DateTime selectedDate = DateTime.now();
    TextEditingController amountController = TextEditingController();
    TicketType ticketType = TicketType(ticketName: "", groupId: "");

    List<TicketType> tickets =
        await sl<ITicketTypeRepository>().getTicketTypesByGroupId(data.groupId);

    return showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
              width: 200,
              height: 400,
              child: Column(
                children: [
                  Center(
                      child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    child: const Text(
                      "Tildel bøde",
                      style: TextStyle(fontSize: 25),
                    ),
                  )),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "Bøde",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TBDropdownButton<TicketType>(
                      data: tickets,
                      callback: (val) {
                        amountController.text = val.price.toString();
                        ticketType = val;
                      },
                      itemsLayout: (dynamic value) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              value.ticketName,
                              overflow: TextOverflow
                                  .fade, // Ensures text does not overflow
                              maxLines: 1, // Restricts text to a single line
                              softWrap: false,
                            ),
                          ),
                          Text('${value.price} ,-     ')
                        ],
                      ),
                      hint: ({value}) => Container(
                        child: value.isNotEmpty
                            ? const Text(
                                "Vælg bøde",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.end,
                              )
                            : const Text(
                                "Ingen bøder oprettet",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.end,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          // label: Text(
                          //   'Beløb',
                          //   style: TextStyle(
                          //     fontSize: 20,
                          //   ),
                          // ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        controller: amountController,
                      ),
                    ),
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      // height: 50,
                      child: OutlinedButton(
                        onPressed: () async {
                          await _selectDate(context, selectedDate)
                              .then((value) => selectedDate = value);
                          setState(() {});
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            '${selectedDate.day.toString()} ${month[selectedDate.month - 1]} ${selectedDate.year.toString()}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: TBFilledButton(
                      roundBorder: 25,
                      onPressed: () async {
                        if (amountController.text.isNotEmpty &&
                            ticketType.ticketTypeId.isNotEmpty) {
                          Post po = Post(
                            adminId: sl<TBUser>().userId,
                            adminName: sl<TBUser>().userName,
                            dateIssued:
                                '${selectedDate.day.toString()}-${selectedDate.month.toString()}-${selectedDate.year.toString()}',
                            groupId: data.groupId,
                            price: int.parse(amountController.text),
                            receiverId: data.userId,
                            receiverName: data.userName,
                            ticketTypeId: ticketType.ticketTypeId,
                            ticketTypeName: ticketType.ticketName,
                          );
                          await sl<IPostRepository>().addPost(po);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      text: "Tildel bøde",
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  Future<void> seeTickets(BuildContext context, String userId, String userName,
      String groupId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 70,
          height: MediaQuery.of(context).size.height - 100,
          child: Column(children: [
            SizedBox(height: 15),
            Text(userName, style: TextStyle(fontSize: 25)),
            StreamBuilder(
                  stream: sl<GroupViewModel>()
                      .getPostsByReceiverIdAndGroupId(userId, groupId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30),
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          height: MediaQuery.of(context).size.height - 270,
                          width: MediaQuery.of(context).size.width - 70,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: data!.isEmpty
                              ? SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Center(
                                    child: Text('Ingen bøder på oversigten'),
                                  ),
                                )
                              : ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: false,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Stack(children: [
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        margin: const EdgeInsets.only(
                                            bottom: 5,
                                            left: 8,
                                            right: 8,
                                            top: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data[index]
                                                          .ticketTypeName,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                      overflow: TextOverflow
                                                          .fade, // Truncates the text with ellipsis if it's too long
                                                      softWrap:
                                                          true, // Allows the text to wrap onto a new line if necessary
                                                    ),
                                                    Text(
                                                      data[index].dateIssued ??
                                                          '01-01-24',
                                                      style: const TextStyle(
                                                          fontSize: 10),
                                                      softWrap: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                data[index]
                                                    .price
                                                    .toString()
                                                    .replaceAll('-', ''),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: data[index].price < 0
                                                        ? Colors.green
                                                        : Colors.red),
                                              )
                                            ]),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          margin:
                                          EdgeInsets.only(right: 5),
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () async => deletePost(data[index]),
                                              child: Container(
                                                padding: EdgeInsets.all(4), // Justér størrelsen på cirklen
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[300],
                                                    border: Border.all(color: Colors.black, width: 1)
                                                ),
                                                child: Icon(Icons.delete, size: 20),
                                              ),
                                            ),
                                          ),
                                        )
                                      ),
                                    ]);
                                  }),
                        ),
                      );
                    } else {
                      return const TBCircularProgressIndicator();
                    }
                  }),
            SizedBox(height: 10),
            TBFilledButton(
              text: 'OK',
              width: MediaQuery.of(context).size.width /2,
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ]),
        ),
      ),
    );
  }


}
