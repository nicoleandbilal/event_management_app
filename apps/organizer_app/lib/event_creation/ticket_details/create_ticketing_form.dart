// create_ticketing_form.dart

import 'package:flutter/material.dart';
import 'package:organizer_app/event_creation/ticket_details/add_ticket_dialog.dart';
import 'package:shared/widgets/custom_padding_button.dart';
import 'package:shared/models/ticket_model.dart';

class CreateTicketForm extends StatelessWidget {
  final String eventId;

  const CreateTicketForm({super.key, required this.eventId});

  // Method to collect ticket data for saving
  static Ticket collectTicketData({
    required String eventId,
    required String ticketName,
    required double ticketPrice,
    required int availableQuantity,
    required bool isRefundable,
  }) {
    return Ticket(
      ticketId: '',
      eventId: eventId,
      ticketType: 'Paid',
      ticketName: ticketName,
      ticketPrice: ticketPrice,
      availableQuantity: availableQuantity,
      soldQuantity: 0,
      isRefundable: isRefundable,
      isSoldOut: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomPaddingButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AddTicketDialog(eventId: eventId),
              );
            },
            label: 'Create New Ticket',
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey,
              minimumSize: const Size(double.infinity, 40),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const Divider(height: 1, color: Colors.grey),
      ],
    );
  }
}
