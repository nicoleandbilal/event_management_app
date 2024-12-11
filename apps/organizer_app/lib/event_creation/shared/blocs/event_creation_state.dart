// event_creation_state.dart

import 'package:shared/models/event_model.dart';

abstract class EventCreationState {}

/// Initial state when the modal is opened
class EventCreationInitial extends EventCreationState {}

/// State when the event creation process is initializing
class EventCreationLoading extends EventCreationState {}

/// State when the event creation process is ready with a pre-draft event
class EventCreationReady extends EventCreationState {
  final Event event;
  final int currentPageIndex;

  EventCreationReady(this.event, this.currentPageIndex);
}

/// State when the event is being finalized
class EventCreationFinalizing extends EventCreationState {}

/// State when the event creation process is complete
class EventCreationComplete extends EventCreationState {}

/// State for errors
class EventCreationError extends EventCreationState {
  final String message;

  EventCreationError(this.message);
}


/*

import 'package:equatable/equatable.dart';

abstract class EventCreationState extends Equatable {
  const EventCreationState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the event creation process
class EventCreationInitial extends EventCreationState {}

/// Loading state during async operations
class EventCreationLoading extends EventCreationState {}

/// State when the event draft is successfully initialized
class EventCreationLoaded extends EventCreationState {
  final String eventId;
  final int currentStep;

  const EventCreationLoaded({
    required this.eventId,
    required this.currentStep,
  });

  EventCreationLoaded copyWith({int? currentStep}) {
    return EventCreationLoaded(
      eventId: eventId,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  @override
  List<Object?> get props => [eventId, currentStep];
}

/// State indicating a successful save
class EventCreationSaved extends EventCreationState {}

/// State when the event is successfully published
class EventCreationCompleted extends EventCreationState {}

/// State indicating an error
class EventCreationError extends EventCreationState {
  final String message;

  const EventCreationError(this.message);

  @override
  List<Object?> get props => [message];
}

*/