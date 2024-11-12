// ticket_details_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/repositories/ticket_repository.dart';
import 'package:shared/models/ticket_model.dart';
import 'ticket_details_event.dart';
import 'ticket_details_state.dart';

class TicketDetailsBloc extends Bloc<TicketDetailsEvent, TicketDetailsState> {
  final TicketRepository ticketRepository;
  Ticket? draftTicket; // Holds the current draft ticket

  TicketDetailsBloc({required this.ticketRepository}) : super(TicketDetailsInitial()) {
    on<InitializeDraftTicket>(_onInitializeDraftTicket);
    on<SaveTicketDetailsEvent>(_onSaveTicketDetailsEvent);
  }

  // Initializes a ticket draft
  Future<void> _onInitializeDraftTicket(
      InitializeDraftTicket event, Emitter<TicketDetailsState> emit) async {
    emit(TicketDetailsLoading());
    try {
      draftTicket = Ticket(
        ticketId: '',
        eventId: event.eventId,
        ticketType: 'Standard',
        ticketName: '',
        ticketPrice: 0.0,
        availableQuantity: 0,
        soldQuantity: 0,
        isRefundable: true,
        isSoldOut: false,
      );

      final ticketId = await ticketRepository.createDraftTicket(event.eventId, draftTicket!);
      draftTicket = draftTicket!.copyWith(ticketId: ticketId);
      emit(TicketDraftInitialized(ticketId: ticketId));
    } catch (e) {
      emit(TicketDetailsFailure("Failed to initialize draft ticket: $e"));
    }
  }

  // Saves ticket details
  Future<void> _onSaveTicketDetailsEvent(
      SaveTicketDetailsEvent event, Emitter<TicketDetailsState> emit) async {
    emit(TicketDetailsLoading());
    if (draftTicket != null) {
      draftTicket = event.ticket.copyWith(ticketId: draftTicket!.ticketId);

      try {
        await ticketRepository.updateDraftTicket(draftTicket!.eventId, draftTicket!.ticketId, draftTicket!.toJson());
        emit(TicketDetailsSaved()); // Emit saved state
      } catch (e) {
        emit(TicketDetailsFailure("Failed to save ticket details: $e"));
      }
    }
  }
}
