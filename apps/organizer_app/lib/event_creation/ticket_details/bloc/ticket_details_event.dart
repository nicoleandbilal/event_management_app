// ticket_details_event.dart

import 'package:equatable/equatable.dart';
import 'package:shared/models/ticket_model.dart';

abstract class TicketDetailsEvent extends Equatable {
  const TicketDetailsEvent();

  @override
  List<Object?> get props => [];
}

// Initialize a new draft ticket
class InitializeDraftTicket extends TicketDetailsEvent {
  final String eventId;

  const InitializeDraftTicket({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

// Save ticket details as a draft
class SaveTicketDetailsEvent extends TicketDetailsEvent {
  final Ticket ticket;

  const SaveTicketDetailsEvent({required this.ticket});

  @override
  List<Object?> get props => [ticket];
}

// Add ticket to the ticket list
class AddTicketToListEvent extends TicketDetailsEvent {
  final Ticket ticket;

  const AddTicketToListEvent({required this.ticket});

  @override
  List<Object?> get props => [ticket];
}
