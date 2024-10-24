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

// Event to update the event image URL
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
