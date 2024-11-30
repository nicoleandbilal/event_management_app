import 'package:equatable/equatable.dart';
import 'package:shared/models/ticket_model.dart';

/// Base class for all Ticket Details states
abstract class TicketDetailsState extends Equatable {
  const TicketDetailsState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the Ticket Details step
class TicketDetailsInitial extends TicketDetailsState {}

/// State indicating a loading operation
class TicketDetailsLoading extends TicketDetailsState {}

/// State when the ticket list is successfully updated
class TicketListUpdated extends TicketDetailsState {
  final List<Ticket> ticketList;

  const TicketListUpdated(this.ticketList);

  @override
  List<Object?> get props => [ticketList];
}

/// State indicating a failure during ticket operations
class TicketDetailsFailure extends TicketDetailsState {
  final String error;

  const TicketDetailsFailure(this.error);

  @override
  List<Object?> get props => [error];
}

/// State when a draft ticket is initialized
class TicketDraftInitialized extends TicketDetailsState {
  final Ticket draftTicket;

  const TicketDraftInitialized(this.draftTicket);

  @override
  List<Object?> get props => [draftTicket];
}