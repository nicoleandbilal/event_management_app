import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_event.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_state.dart';
import 'package:organizer_app/event_creation/save_event_service.dart';

class EventCreationBloc extends Bloc<EventCreationEvent, EventCreationState> {
  final SaveEventService saveEventService;
  final Logger logger;

  EventCreationBloc({
    required this.saveEventService,
    required this.logger,
  }) : super(EventCreationInitial()) {
    on<InitializeEventCreation>(_onInitializeEventCreation);
    on<NextStep>(_onNextStep);
    on<PreviousStep>(_onPreviousStep);
    on<SaveAndExit>(_onSaveAndExit);
    on<PublishEvent>(_onPublishEvent);
  }

  Future<void> _onInitializeEventCreation(
      InitializeEventCreation event, Emitter<EventCreationState> emit) async {
    emit(EventCreationLoading());
    try {
      final eventId = await saveEventService.eventRepository.initializeEventDraft(event.userId);

      // Ensure basic details have default values during initialization
      await saveEventService.saveStepData(
        eventId: eventId,
        step: EventStep.BasicDetails,
        updatedData: {
          'eventName': 'Untitled Event',
          'startDateTime': DateTime.now(),
          'endDateTime': DateTime.now().add(const Duration(hours: 1)),
          'venue': 'TBD',
        },
        isPublishing: false, // Allow default initialization without full validation
      );

      emit(EventCreationLoaded(eventId: eventId, currentStep: 0));
    } catch (e) {
      logger.e("Failed to initialize event creation: $e");
      emit(const EventCreationError("Failed to initialize event creation."));
    }
  }

  Future<void> _onNextStep(NextStep event, Emitter<EventCreationState> emit) async {
    if (state is! EventCreationLoaded) return;
    final currentState = state as EventCreationLoaded;
    emit(EventCreationLoading());
    try {
      // Save data for the current step before moving to the next step
      await saveEventService.saveStepData(
        eventId: currentState.eventId,
        step: event.step,
        updatedData: event.updatedData,
        isPublishing: false, // Skip strict validation for intermediate steps
      );

      emit(currentState.copyWith(currentStep: currentState.currentStep + 1));
    } catch (e) {
      logger.e("Failed to save data for step: ${event.step}. Error: $e");
      emit(const EventCreationError("Failed to save data for the current step."));
    }
  }

  Future<void> _onPreviousStep(
      PreviousStep event, Emitter<EventCreationState> emit) async {
    if (state is! EventCreationLoaded) return;

    final currentState = state as EventCreationLoaded;

    if (currentState.currentStep <= 0) return;

    emit(currentState.copyWith(currentStep: currentState.currentStep - 1));
  }

  Future<void> _onSaveAndExit(
      SaveAndExit event, Emitter<EventCreationState> emit) async {
    emit(EventCreationLoading());
    try {
      // Save only the current step's data before exiting
      if (event.step == EventStep.BasicDetails) {
        await saveEventService.saveStepData(
          eventId: event.eventId,
          step: EventStep.BasicDetails,
          updatedData: event.updatedData,
          isPublishing: false, // Skip validation for Save & Exit
        );
      } else if (event.step == EventStep.TicketDetails) {
        final ticketList = event.updatedData['tickets'] as List<Map<String, dynamic>>? ?? [];
        if (ticketList.isNotEmpty) {
          await saveEventService.saveStepData(
            eventId: event.eventId,
            step: EventStep.TicketDetails,
            updatedData: event.updatedData,
            isPublishing: false,
          );
        } else {
          logger.w("No tickets provided for EventStep.TicketDetails during Save & Exit.");
        }
      }

      emit(EventCreationSaved());
    } catch (e) {
      logger.e("Failed to save and exit for event ID: ${event.eventId}. Error: $e");
      emit(const EventCreationError("Failed to save and exit."));
    }
  }

  Future<void> _onPublishEvent(
      PublishEvent event, Emitter<EventCreationState> emit) async {
    emit(EventCreationLoading());
    try {
      // Validate and publish the event
      await saveEventService.publishEvent(event.eventId);
      emit(EventCreationCompleted());
    } catch (e) {
      logger.e("Failed to publish event ID: ${event.eventId}. Error: $e");
      emit(const EventCreationError("Failed to publish the event."));
    }
  }
}