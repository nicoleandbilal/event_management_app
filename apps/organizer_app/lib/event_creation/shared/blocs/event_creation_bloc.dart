// event_creation_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/models/event_model.dart';
import 'event_creation_event.dart';
import 'event_creation_state.dart';
import '../services/event_creation_service.dart';

class EventCreationBloc extends Bloc<EventCreationEvent, EventCreationState> {
  final EventCreationService _service;
  Event? _currentEvent;
  int _currentPageIndex = 0;

  EventCreationBloc(this._service, {required EventCreationService eventCreationService}) : super(EventCreationInitial()) {
    on<InitializeEventCreation>(_onInitializeEventCreation);
    on<NavigateNext>(_onNavigateNext);
    on<NavigateBack>(_onNavigateBack);
    on<SaveAndExit>(_onSaveAndExit);
    on<FinalizeEventCreation>(_onFinalizeEventCreation);
  }

  Future<void> _onInitializeEventCreation(
      InitializeEventCreation event, Emitter<EventCreationState> emit) async {
    emit(EventCreationLoading());
    try {
      _currentEvent = await _service.createPreDraftEvent(event.createdByUserId);
      emit(EventCreationReady(_currentEvent!, _currentPageIndex));
    } catch (e) {
      emit(EventCreationError("Failed to initialize event creation: $e"));
    }
  }

  void _onNavigateNext(NavigateNext event, Emitter<EventCreationState> emit) {
    if (_currentEvent == null) return;
    _currentPageIndex++;
    emit(EventCreationReady(_currentEvent!, _currentPageIndex));
  }

  void _onNavigateBack(NavigateBack event, Emitter<EventCreationState> emit) {
    if (_currentEvent == null || _currentPageIndex == 0) return;
    _currentPageIndex--;
    emit(EventCreationReady(_currentEvent!, _currentPageIndex));
  }

  Future<void> _onSaveAndExit(
      SaveAndExit event, Emitter<EventCreationState> emit) async {
    if (_currentEvent == null) return;
    try {
      await _service.updateEventStatus(_currentEvent!.eventId, 'draft');
      emit(EventCreationComplete());
    } catch (e) {
      emit(EventCreationError("Failed to save and exit: $e"));
    }
  }

  Future<void> _onFinalizeEventCreation(
      FinalizeEventCreation event, Emitter<EventCreationState> emit) async {
    emit(EventCreationFinalizing());
    try {
      await _service.finalizeEvent(event.event);
      emit(EventCreationComplete());
    } catch (e) {
      emit(EventCreationError("Failed to finalize event: $e"));
    }
  }
}





/*

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_event.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_state.dart';
import 'package:organizer_app/event_creation/shared/services/save_event_service.dart';

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

*/