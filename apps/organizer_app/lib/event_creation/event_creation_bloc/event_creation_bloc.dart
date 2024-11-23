import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_event.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_state.dart';
import 'package:organizer_app/utils/event_id_sanitizer.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/ticket_repository.dart';

/// Bloc for managing the event creation process, including initialization, navigation, and publishing.
class EventCreationBloc extends Bloc<EventCreationEvent, EventCreationState> {
  final EventRepository eventRepository;
  final TicketRepository ticketRepository;
  final Logger _logger;

  EventCreationBloc({
    required this.eventRepository,
    required this.ticketRepository,
    required basicDetailsBloc, 
    required ticketDetailsBloc,
    required Logger logger,
  })  : _logger = logger,
        super(EventCreationInitial()) {
    on<InitializeEventCreation>(_onInitializeEventCreation);
    on<NextStep>(_onNextStep);
    on<PreviousStep>(_onPreviousStep);
    on<SaveAndExit>(_onSaveAndExit);
    on<PublishEvent>(_onPublishEvent);
    on<CancelEventCreation>(_onCancelEventCreation);
    on<MoveToSummary>(_onMoveToSummary);
  }

  // Step 1: Method to initialize the event creation process with "pre-draft" status
  Future<void> _onInitializeEventCreation(
      InitializeEventCreation event, Emitter<EventCreationState> emit) async {
    emit(EventCreationLoading());
    try {
      // Call repository to create a pre-draft entry and retrieve eventId
      final rawEventId = await eventRepository.initializeEventDraft(event.userId);
      final sanitizedEventId = EventIdSanitizer.sanitize(rawEventId);

      if (!EventIdSanitizer.isValid(sanitizedEventId)) {
        throw Exception("Invalid event ID format.");
      }

      _logger.i('Initialized event draft with sanitized ID: $sanitizedEventId');
      emit(EventCreationLoaded(eventId: sanitizedEventId, currentStep: 0));
    } catch (error) {
      _logger.e('Error initializing event draft: $error');
      emit(EventCreationError("Failed to initialize event draft."));
    }
  }

  // Step 2: Handle navigation to the next step, saving any form data if provided
  Future<void> _onNextStep(NextStep event, Emitter<EventCreationState> emit) async {
    if (state is EventCreationLoaded) {
      final currentState = state as EventCreationLoaded;

      try {
        // Save form data if provided
        if (event.formData != null) {
          await _savePartialData(currentState.eventId, event.formData!);
        }

        emit(currentState.copyWith(currentStep: currentState.currentStep + 1));
      } catch (error) {
        _logger.e('Error saving data for event ID ${currentState.eventId}: $error');
        emit(EventCreationError("Failed to save data for the next step."));
      }
    }
  }

  // Step 3: Handle navigation to the previous step
  void _onPreviousStep(PreviousStep event, Emitter<EventCreationState> emit) {
    if (state is EventCreationLoaded) {
      final currentState = state as EventCreationLoaded;
      emit(currentState.copyWith(currentStep: currentState.currentStep - 1));
    }
  }

  // Step 4: Save current draft data and exit the event creation process
  Future<void> _onSaveAndExit(
      SaveAndExit event, Emitter<EventCreationState> emit) async {
    emit(EventCreationLoading());
    try {
      final sanitizedEventId = EventIdSanitizer.sanitize(event.eventId);
      await eventRepository.updateDraftEvent(sanitizedEventId, event.updatedData);
      _logger.i('Draft saved for event ID: $sanitizedEventId');
      emit(EventCreationSaved());
    } catch (error) {
      _logger.e('Error saving draft for event ID ${event.eventId}: $error');
      emit(EventCreationError("Failed to save and exit."));
    }
  }

  // Step 5: Finalize and publish the event as "live"
  Future<void> _onPublishEvent(PublishEvent event, Emitter<EventCreationState> emit) async {
    emit(EventCreationLoading());
    try {
      await eventRepository.publishEvent(event.event);
      _logger.i('Event published successfully with ID: ${event.event.eventId}');
      emit(EventCreationCompleted());
    } catch (error) {
      _logger.e('Error publishing event ID ${event.event.eventId}: $error');
      emit(EventCreationError("Failed to publish the event."));
    }
  }

  // Step 6: Cancel the event creation process and mark the event as "cancelled"
  Future<void> _onCancelEventCreation(
      CancelEventCreation event, Emitter<EventCreationState> emit) async {
    emit(EventCreationLoading());
    try {
      final sanitizedEventId = EventIdSanitizer.sanitize(event.eventId);
      await eventRepository.cancelEvent(sanitizedEventId);
      _logger.i('Event creation cancelled for ID: $sanitizedEventId');
      emit(EventCreationCancelled());
    } catch (error) {
      _logger.e('Error cancelling event creation for ID ${event.eventId}: $error');
      emit(EventCreationError("Failed to cancel event creation."));
    }
  }

  // Step 7: Move to the summary page for review before publishing
  void _onMoveToSummary(MoveToSummary event, Emitter<EventCreationState> emit) {
    if (state is EventCreationLoaded) {
      emit(EventSummaryState(event: event.event, tickets: event.tickets));
      _logger.i('Moved to summary for event ID: ${event.event.eventId}');
    }
  }

  // Helper function to save partial data during the multi-step process
  Future<void> _savePartialData(String eventId, Map<String, dynamic> data) async {
    final sanitizedEventId = EventIdSanitizer.sanitize(eventId);

    try {
      await eventRepository.updateDraftEvent(sanitizedEventId, data);
      _logger.i('Partial data saved for event ID: $sanitizedEventId');
    } catch (error) {
      _logger.e('Error saving partial data for event ID $sanitizedEventId: $error');
      throw Exception("Failed to save partial data.");
    }
  }
}
