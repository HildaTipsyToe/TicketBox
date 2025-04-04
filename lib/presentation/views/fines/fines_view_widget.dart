import 'package:flutter/material.dart';
import 'package:ticketbox/presentation/views/fines/fines_view_model.dart';
import 'package:ticketbox/presentation/views/widget/process_indicator/circular_progress_indicator.dart';

import '../widget/buttons/icon_button.dart';

class FinesViewWidget extends StatelessWidget {
  final FinesViewModel model;

  final String groupId;
  final String roleId;

  const FinesViewWidget({
    super.key,
    required this.groupId,
    required this.roleId,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: model.getTicketsTypeByGroupId(groupId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final fines = snapshot.data;
            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    height: MediaQuery.of(context).size.height - 120,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.circular(3)),
                    child: fines!.isEmpty
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
                            itemCount: fines.length,
                            itemBuilder: (BuildContext context, int index) {
                              final data = fines[index];
                              return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: [
                                          const Icon(Icons.circle_sharp,
                                              size: 5),
                                          SizedBox(width: 10),
                                          SizedBox(width: MediaQuery.of(context).size.width * 0.55, child: Text(data.ticketName, style: const TextStyle(fontSize: 20), softWrap: true,)),
                                          // Text(
                                          //   '  ${data.ticketName}',
                                          //   style:
                                          //       const TextStyle(fontSize: 20),
                                          // ),
                                        ]),
                                        roleId == '1' ? Row(children: [
                                          Text(data.price.toString(),
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(width: 5),
                                          TBIconButton(
                                              icon: Icons.delete,
                                              size: 25,
                                              iconSize: 20,
                                              onPressed: () {
                                                model.deleteTicketType(data.ticketTypeId);
                                              },
                                          )
                                        ])
                                            : Text(data.price.toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ]));
                            })));
          } else {
            return const TBCircularProgressIndicator();
          }
        });
  }
}
