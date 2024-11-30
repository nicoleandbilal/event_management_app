import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_event.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_state.dart';
import 'package:organizer_app/event_creation/ticket_details/ticket_details_service.dart';
import 'package:shared/models/ticket_model.dart';
import 'package:logger/logger.dart';

class TicketDetailsBloc extends Bloc<TicketDetailsEvent, TicketDetailsState> {
  final TicketDetailsService ticketDetailsService;
  final Logger logger;
  final String eventId;

  TicketDetailsBloc({
    required this.ticketDetailsService,
    required this.logger,
    required this.eventId,
  }) : super(TicketDetailsInitial()) {
    on<InitializeDraftTicket>(_onInitializeDraftTicket);
    on<AddTicketToEvent>(_onAddTicketToEvent);
    on<FetchTicketList>(_onFetchTicketList);
    on<DeleteTicket>(_onDeleteTicket);
  }

  void _onInitializeDraftTicket(
      InitializeDraftTicket event, Emitter<TicketDetailsState> emit) {
    emit(TicketDetailsLoading());
    try {
      final draftTicket = Ticket(
        ticketId: '',
        eventId: event.eventId,
        ticketType: 'Paid',
        ticketName: '',
        ticketPrice: 0.0,
        availableQuantity: 0,
        soldQuantity: 0,
        description: '',
        isRefundable: true,
        ticketSaleStartDateTime: null,
        ticketSaleEndDateTime: null,
      );
      emit(TicketDraftInitialized(draftTicket));
    } catch (e) {
      logger.e('Error initializing draft ticket: $e');
      emit(const TicketDetailsFailure('Failed to initialize draft ticket.'));
    }
  }

  Future<void> _onAddTicketToEvent(
      AddTicketToEvent event, Emitter<TicketDetailsState> emit) async {
    emit(TicketDetailsLoading());
    try {
      await ticketDetailsService.addTicket(event.eventId, event.ticket);
      final tickets = await ticketDetailsService.getTickets(event.eventId);
      emit(TicketListUpdated(tickets));
    } catch (e) {
      logger.e('Error adding ticket: $e');
      emit(const TicketDetailsFailure('Failed to add ticket.'));
    }
  }

  Future<void> _onFetchTicketList(
      FetchTicketList event, Emitter<TicketDetailsState> emit) async {
    emit(TicketDetailsLoading());
    try {
      final tickets = await ticketDetailsService.getTickets(event.eventId);
      emit(TicketListUpdated(tickets));
    } catch (e) {
      logger.e('Error fetching tickets: $e');
      emit(const TicketDetailsFailure('Failed to fetch tickets.'));
    }
  }

  Future<void> _onDeleteTicket(
      DeleteTicket event, Emitter<TicketDetailsState> emit) async {
    emit(TicketDetailsLoading());
    try {
      await ticketDetailsService.deleteTicket(event.eventId, event.ticketId);
      final tickets = await ticketDetailsService.getTickets(event.eventId);
      emit(TicketListUpdated(tickets));
    } catch (e) {
      logger.e('Error deleting ticket: $e');
      emit(const TicketDetailsFailure('Failed to delete ticket.'));
    }
  }
}