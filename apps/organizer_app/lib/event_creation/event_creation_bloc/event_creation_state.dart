// event_creation_state.dart

import 'package:equatable/equatable.dart';
import 'package:shared/models/event_model.dart';
import 'package:shared/models/ticket_model.dart';

abstract class EventCreationState extends Equatable {
  const EventCreationState();

  @override
  List<Object?> get props => [];
}

// Initial state of the event creation
class EventCreationInitial extends EventCreationState {}

// Loading state for asynchronous operations
class EventCreationLoading extends EventCreationState {}

// State after event draft initialization
class EventCreationLoaded extends EventCreationState {
  final String eventId;
  final int currentStep;

  const EventCreationLoaded({required this.eventId, required this.currentStep});

  EventCreationLoaded copyWith({int? currentStep}) {
    return EventCreationLoaded(
      eventId: eventId,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  @override
  List<Object?> get props => [eventId, currentStep];
}

// State when event draft is saved
class EventCreationSaved extends EventCreationState {}

// State for summary view before final submission
class EventSummaryState extends EventCreationState {
  final Event event;
  final List<Ticket> tickets;

  EventSummaryState({required this.event, required this.tickets});

  @override
  List<Object?> get props => [event, tickets];
}

// Completed state when the event is successfully published
class EventCreationCompleted extends EventCreationState {}

// State when the event creation is canceled
class EventCreationCancelled extends EventCreationState {}

// Error state with a message
class EventCreationError extends EventCreationState {
  final String message;

  EventCreationError(this.message);

  @override
  List<Object?> get props => [message];
}
