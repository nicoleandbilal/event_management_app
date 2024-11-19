import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/add_ticket_modal.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_event.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_state.dart';

class TicketScreen extends StatelessWidget {
  final String eventId;

  const TicketScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
      ),
      body: BlocConsumer<TicketDetailsBloc, TicketDetailsState>(
        listener: (context, state) {
          if (state is TicketDetailsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<TicketDetailsBloc>();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    bloc.add(InitializeDraftTicket(eventId: eventId));
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => AddTicketModal(eventId: eventId),
                    );
                  },
                  child: const Text('Add Tickets'),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: state is TicketAddedToList
                      ? ListView.builder(
                          itemCount: state.ticketList.length,
                          itemBuilder: (context, index) {
                            final ticket = state.ticketList[index];
                            return ListTile(
                              title: Text(ticket.ticketName),
                              subtitle: Text('Price: \$${ticket.ticketPrice}'),
                            );
                          },
                        )
                      : const Center(
                          child: Text('No tickets added yet.'),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
