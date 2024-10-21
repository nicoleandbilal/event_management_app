// create_event_form_event.dart

import 'package:equatable/equatable.dart';
import 'package:shared/models/event_model.dart';

abstract class CreateEventFormEvent extends Equatable {
  const CreateEventFormEvent();

  @override
  List<Object?> get props => [];
}

class SubmitCreateEventForm extends CreateEventFormEvent {
  final Event event;

  const SubmitCreateEventForm(this.event);

  @override
  List<Object?> get props => [event];
}

class UpdateCreateEventName extends CreateEventFormEvent {
  final String eventName;

  const UpdateCreateEventName(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

class UpdateCreateEventDescription extends CreateEventFormEvent {
  final String description;

  const UpdateCreateEventDescription(this.description);

  @override
  List<Object?> get props => [description];
}

class UpdateCreateEventStartDateTime extends CreateEventFormEvent {
  final DateTime startDateTime;

  const UpdateCreateEventStartDateTime(this.startDateTime);

  @override
  List<Object?> get props => [startDateTime];
}

class UpdateCreateEventEndDateTime extends CreateEventFormEvent {
  final DateTime endDateTime;

  const UpdateCreateEventEndDateTime(this.endDateTime);

  @override
  List<Object?> get props => [endDateTime];
}

class UpdateCreateEventImageUrl extends CreateEventFormEvent {
  final String imageUrl;

  const UpdateCreateEventImageUrl(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

// NEW: Event to handle image deletion
class DeleteCreateEventImage extends CreateEventFormEvent {
  const DeleteCreateEventImage();

  @override
  List<Object?> get props => [];
}
