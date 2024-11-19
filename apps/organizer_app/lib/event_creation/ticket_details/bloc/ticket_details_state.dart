// ticket_details_state.dart

import 'package:equatable/equatable.dart';
import 'package:shared/models/ticket_model.dart';

abstract class TicketDetailsState extends Equatable {
  const TicketDetailsState();

  @override
  List<Object?> get props => [];
}

// Initial state
class TicketDetailsInitial extends TicketDetailsState {}

// Loading state
class TicketDetailsLoading extends TicketDetailsState {}

// Draft initialized with ticket data
class TicketDraftInitialized extends TicketDetailsState {
  final String ticketId;

  const TicketDraftInitialized({required this.ticketId});

  @override
  List<Object?> get props => [ticketId];
}

// State when ticket details are saved successfully
class TicketDetailsSaved extends TicketDetailsState {}

// State when a ticket is added to the list
class TicketAddedToList extends TicketDetailsState {
  final List<Ticket> ticketList;

  const TicketAddedToList({required this.ticketList});

  @override
  List<Object?> get props => [ticketList];
}

// Error state in ticket details
class TicketDetailsFailure extends TicketDetailsState {
  final String error;

  const TicketDetailsFailure(this.error);

  @override
  List<Object?> get props => [error];
}
