import 'package:flutter/material.dart';
import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/domain/entities/tickettype.dart';
import 'package:ticketbox/infrastructure/repository/tickettype_repository.dart';
import 'package:ticketbox/presentation/views/base/base_view_model.dart';

class FinesViewModel extends BaseViewModel {
  FinesViewModel();

  TextEditingController ticketNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  Stream<List<TicketType>> getTicketsTypeByGroupId(groupId) {
    Stream<List<TicketType>> tempTickets =
        sl<ITicketTypeRepository>().getTicketTypesByGroupIdStream(groupId);
    return tempTickets;
  }

  saveFine(String groupId) async {
    // Retreiving the user data.
    final ticketName = ticketNameController.text;

    final price = int.parse(priceController.text);

    ticketNameController.text = '';
    priceController.text = '';

    final newTicket = TicketType(
      ticketName: ticketName,
      groupId: groupId,
      price: price,
    );

    await sl<ITicketTypeRepository>().addTicketType(newTicket.toJson());
  }

  addFineDialog(BuildContext context, String groupId) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Opret bøde'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      label: Text('Bødenavn'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    controller: ticketNameController,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      label: Text('Takst'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    controller: priceController,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuller'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Gem'),
              onPressed: () async {
                await saveFine(groupId);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
