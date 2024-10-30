import 'package:equatable/equatable.dart';
import 'package:shared/models/event_model.dart';

abstract class CreateEventFormEvent extends Equatable {
  const CreateEventFormEvent();
}

class SubmitCreateEventForm extends CreateEventFormEvent {
  final Event event;

  const SubmitCreateEventForm(this.event);

  @override
  List<Object?> get props => [event];
}

class UpdateImageUrls extends CreateEventFormEvent {
  final String fullImageUrl;
  final String croppedImageUrl;

  const UpdateImageUrls({required this.fullImageUrl, required this.croppedImageUrl});

  @override
  List<Object?> get props => [fullImageUrl, croppedImageUrl];
}

class DeleteImageUrls extends CreateEventFormEvent {
  const DeleteImageUrls();

  @override
  List<Object?> get props => [];
}
