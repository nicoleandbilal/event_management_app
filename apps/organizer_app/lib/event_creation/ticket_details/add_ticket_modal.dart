import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_event.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_state.dart';

class AddTicketModal extends StatelessWidget {
  final String eventId;

  const AddTicketModal({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TicketDetailsBloc>();
    final ticketNameController = TextEditingController();
    final ticketPriceController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: BlocConsumer<TicketDetailsBloc, TicketDetailsState>(
        listener: (context, state) {
          if (state is TicketDetailsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          if (state is TicketDetailsSaved) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Add Ticket',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ticketNameController,
                decoration: const InputDecoration(labelText: 'Ticket Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ticketPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Ticket Price'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (ticketNameController.text.isEmpty ||
                      ticketPriceController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All fields are required.')),
                    );
                    return;
                  }

                  final ticket = bloc.draftTicket!.copyWith(
                    ticketName: ticketNameController.text,
                    ticketPrice: double.tryParse(ticketPriceController.text) ?? 0.0,
                  );

                  bloc.add(SaveTicketDetailsEvent(ticket: ticket));
                  bloc.add(AddTicketToListEvent(ticket: ticket));
                },
                child: const Text('Save Ticket'),
              ),
            ],
          );
        },
      ),
    );
  }
}
