import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/add_ticket_modal.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_event.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_state.dart';

class TicketDetailsScreen extends StatelessWidget {
  final String eventId;

  const TicketDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TicketDetailsBloc(
        ticketDetailsService: context.read(),
        logger: context.read(),
        eventId: eventId,
      )..add(FetchTicketList(eventId: eventId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ticket Details'),
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
            if (state is TicketDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TicketListUpdated) {
              return _buildTicketList(context, state.ticketList);
            }
            return const Center(child: Text('No tickets added yet.'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context
                .read<TicketDetailsBloc>()
                .add(InitializeDraftTicket(eventId: eventId));
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => AddTicketModal(eventId: eventId),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTicketList(BuildContext context, List<dynamic> ticketList) {
    if (ticketList.isEmpty) {
      return const Center(
        child: Text(
          'No tickets added yet. Tap the "+" button to add tickets.',
          style: TextStyle(fontSize: 16.0),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: ticketList.length,
        itemBuilder: (context, index) {
          final ticket = ticketList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(ticket.ticketName),
              subtitle: Text(
                'Price: \$${ticket.ticketPrice}, Available: ${ticket.availableQuantity}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context
                      .read<TicketDetailsBloc>()
                      .add(DeleteTicket(eventId: eventId, ticketId: ticket.ticketId));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}