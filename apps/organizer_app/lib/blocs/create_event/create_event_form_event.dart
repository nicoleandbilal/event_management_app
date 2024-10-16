import 'package:equatable/equatable.dart';
import 'package:organizer_app/models/create_event_model.dart';

// Define abstract base class for all events
abstract class CreateEventFormEvent extends Equatable {
  const CreateEventFormEvent();

  @override
  List<Object?> get props => [];
}

// Event for submitting the event form
class SubmitCreateEventForm extends CreateEventFormEvent {
  final CreateEvent event;  // Pass the event data that needs to be submitted

  const SubmitCreateEventForm(this.event);

  @override
  List<Object?> get props => [event];
}

// Event for updating the event name
class UpdateCreateEventName extends CreateEventFormEvent {
  final String eventName;

  const UpdateCreateEventName(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

// Event for updating the event description
class UpdateCreateEventDescription extends CreateEventFormEvent {
  final String description;

  const UpdateCreateEventDescription(this.description);

  @override
  List<Object?> get props => [description];
}

// Event for updating the event's start date and time
class UpdateCreateEventStartDateTime extends CreateEventFormEvent {
  final DateTime startDateTime;

  const UpdateCreateEventStartDateTime(this.startDateTime);

  @override
  List<Object?> get props => [startDateTime];
}

// Event for updating the event's end date and time
class UpdateCreateEventEndDateTime extends CreateEventFormEvent {
  final DateTime endDateTime;

  const UpdateCreateEventEndDateTime(this.endDateTime);

  @override
  List<Object?> get props => [endDateTime];
}

// Event for updating the event image URL
class UpdateCreateEventImageUrl extends CreateEventFormEvent {
  final String imageUrl;

  const UpdateCreateEventImageUrl(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}