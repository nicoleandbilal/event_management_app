import 'package:equatable/equatable.dart';
import 'package:shared/models/ticket_model.dart';

/// Base class for all Ticket Details events
abstract class TicketDetailsEvent extends Equatable {
  const TicketDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize a draft ticket
class InitializeDraftTicket extends TicketDetailsEvent {
  final String eventId;

  const InitializeDraftTicket({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

/// Event to fetch the ticket list
class FetchTicketList extends TicketDetailsEvent {
  final String eventId;

  const FetchTicketList({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

/// Event to add a ticket to the event
class AddTicketToEvent extends TicketDetailsEvent {
  final String eventId;
  final Ticket ticket;

  const AddTicketToEvent({required this.eventId, required this.ticket});

  @override
  List<Object?> get props => [eventId, ticket];
}

/// Event to delete a ticket
class DeleteTicket extends TicketDetailsEvent {
  final String eventId;
  final String ticketId;

  const DeleteTicket({required this.eventId, required this.ticketId});

  @override
  List<Object?> get props => [eventId, ticketId];
}