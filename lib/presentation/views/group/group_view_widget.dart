import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketbox/presentation/views/group/group_view_model.dart';
import 'package:ticketbox/presentation/views/widget/buttons/filled_button.dart';
import 'package:ticketbox/presentation/views/widget/process_indicator/circular_progress_indicator.dart';

class GroupViewWidget extends StatelessWidget {
  final GroupViewModel model;
  final String receiverId;
  final String groupId;
  final String groupName;
  final String saldo;
  final String roleId;

  const GroupViewWidget({
    super.key,
    required this.model,
    required this.receiverId,
    required this.groupId,
    required this.groupName,
    required this.saldo,
    required this.roleId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: model.getPostsByReceiverIdAndGroupId(receiverId, groupId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                children: [
                  Text(groupName,
                      style:
                          const TextStyle(fontSize: 30, color: Colors.black)),
                  Text(saldo,
                      style: TextStyle(
                          fontSize: 40,
                          color: int.parse(saldo) > 0
                              ? Colors.green
                              : int.parse(saldo) == 0
                                  ? Colors.black
                                  : Colors.red)),
                  TBFilledButton(
                      text: 'Bøder og takster',
                      onPressed: () {
                        context.pushNamed("fines", queryParameters: {
                          'groupId': groupId,
                          'roleId': roleId
                        });
                      },
                      borderColor: Colors.black),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    height: MediaQuery.of(context).size.height - 320,
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
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: false,
                            padding: const EdgeInsets.all(8),
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(
                                      bottom: 5, left: 8, right: 8, top: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data[index].ticketTypeName,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                              softWrap: true,
                                            ),
                                            Text(
                                              data[index].dateIssued ??
                                                  '01-01-24',
                                              style:
                                                  const TextStyle(fontSize: 10),
                                              softWrap: true,
                                            ),
                                          ],
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
                                                    : Colors.red))
                                      ]),
                                ),
                                // Positioned(
                                //   bottom: 0,
                                //   right: 0,
                                //   child: CircleAvatar(
                                //     radius: 20,
                                //     backgroundColor: AppColors.bkBlackTextColor,
                                //     child: CircleAvatar(
                                //       radius: 19,
                                //       backgroundColor: AppColors.bkPrimary,
                                //       child: IconButton(
                                //         onPressed: () {},
                                //         color: AppColors.bkWhiteTextColor,
                                //         icon: const Icon(Icons.people),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // Positioned(
                                //   bottom: 0,
                                //   right: 50,
                                //   child: CircleAvatar(
                                //     radius: 20,
                                //     backgroundColor: AppColors.bkBlackTextColor,
                                //     child: CircleAvatar(
                                //       radius: 19,
                                //       backgroundColor: AppColors.bkPrimary,
                                //       child: IconButton(
                                //         onPressed: () {},
                                //         color: AppColors.bkWhiteTextColor,
                                //         icon: const Icon(Icons.attach_money),
                                //       ),
                                //     ),
                                //   ),
                                // )
                              ]);
                            }),
                  )
                  //)
                ],
              ),
            );
          } else {
            return const TBCircularProgressIndicator();
          }
        });
  }
}
