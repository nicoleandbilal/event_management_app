import 'package:equatable/equatable.dart';

/// Enum representing the steps in the event creation process
enum EventStep { BasicDetails, TicketDetails, FurtherDetails }

/// Base class for all EventCreation events
abstract class EventCreationEvent extends Equatable {
  const EventCreationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the event creation process
class InitializeEventCreation extends EventCreationEvent {
  final String userId;

  const InitializeEventCreation(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Event for navigating to the next step in the creation process
class NextStep extends EventCreationEvent {
  final EventStep step;
  final Map<String, dynamic> updatedData;

  const NextStep({
    required this.step,
    required this.updatedData,
  });

  @override
  List<Object?> get props => [step, updatedData];
}

/// Event for navigating to the previous step
class PreviousStep extends EventCreationEvent {}

/// Event to save the current draft and exit
class SaveAndExit extends EventCreationEvent {
  final String eventId;
  final EventStep step;
  final Map<String, dynamic> updatedData;

  const SaveAndExit({
    required this.eventId,
    required this.step,
    required this.updatedData,
  });

  @override
  List<Object?> get props => [eventId, step, updatedData];
}

/// Event to publish the event and make it live
class PublishEvent extends EventCreationEvent {
  final String eventId;

  const PublishEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}