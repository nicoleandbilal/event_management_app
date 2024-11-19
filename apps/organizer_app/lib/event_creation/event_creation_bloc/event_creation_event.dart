// event_creation_event.dart

import 'package:equatable/equatable.dart';
import 'package:shared/models/event_model.dart';
import 'package:shared/models/ticket_model.dart';

abstract class EventCreationEvent extends Equatable {
  const EventCreationEvent();

  @override
  List<Object?> get props => [];
}

// Event to start the event creation process
class InitializeEventCreation extends EventCreationEvent {
  final String userId;

  InitializeEventCreation(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Event for navigating to the next step in the creation process
class NextStep extends EventCreationEvent {
  final Map<String, dynamic>? formData;

  NextStep({this.formData});

  @override
  List<Object?> get props => [formData];
}

// Event for navigating to the previous step
class PreviousStep extends EventCreationEvent {}

// Event to save the current draft and exit
class SaveAndExit extends EventCreationEvent {
  final String eventId;
  final Map<String, dynamic> updatedData;

  SaveAndExit(this.eventId, this.updatedData);

  @override
  List<Object?> get props => [eventId, updatedData];
}

// Event to publish the event and make it "live"
class PublishEvent extends EventCreationEvent {
  final Event event;

  PublishEvent(this.event);

  @override
  List<Object?> get props => [event];
}

// Event to cancel the event creation process
class CancelEventCreation extends EventCreationEvent {
  final String eventId;

  CancelEventCreation(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

// Event to save data and move to the summary step
class MoveToSummary extends EventCreationEvent {
  final Event event;
  final List<Ticket> tickets;

  MoveToSummary(this.event, this.tickets);

  @override
  List<Object?> get props => [event, tickets];
}
