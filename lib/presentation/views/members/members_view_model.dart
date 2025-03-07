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
import 'package:ticketbox/presentation/views/widget/buttons/filled_button.dart';
import 'package:ticketbox/presentation/views/widget/dropdowns/dropdown_button.dart';

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
            height: 400,
            child: Column(
              children: [
                Center(
                    child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 25),
                  child: const Text(
                    "Inviter medlem",
                    style: TextStyle(fontSize: 25),
                  ),
                )),
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
                              await sl<IMembershipRepository>()
                                  .updateMembership(
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
                                    content: Text(
                                        "Der skal mindst være én administrator"),
                                    duration: Duration(seconds: 3),
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
                    bool canDelete = deletionCheck['canDelete'];
                    String message = deletionCheck['message'];

                    if (canDelete) {
                      // Delete the membership
                      await sl<IMembershipRepository>()
                          .deleteMembership(member);

                      // If the group was deleted, navigate back to the dashboard
                      if (sl<TBUser>().userId == member.userId) {
                        if (context.mounted) {
                          context.pop();
                        }
                        isDeleted = true;
                      } else {
                        Navigator.pop(context);
                      }
                    } else {
                      Navigator.pop(context);
                      // Show a message if the membership cannot be deleted
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  text: member.userId == sl<TBUser>().userId
                      ? "Forlad gruppe"
                      : "Fjern medlem",
                ),
              ],
            )),
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
                      "Name",
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
                              value.ticketName, overflow: TextOverflow.fade, // Ensures text does not overflow
                              maxLines: 1, // Restricts text to a single line
                              softWrap: false,),
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
                        decoration: const InputDecoration(
                          label: Text(
                            'Beløb',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                        if (amountController.text.isNotEmpty) {
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
}
