// create_event_form_event.dart

import 'package:equatable/equatable.dart';

abstract class CreateEventFormEvent extends Equatable {
  const CreateEventFormEvent();

  @override
  List<Object?> get props => [];
}

// Event to move to the next page
class CreateEventFormNextPageEvent extends CreateEventFormEvent {}

// Event to submit the form after all pages are complete
class CreateEventFormSubmitEvent extends CreateEventFormEvent {}
