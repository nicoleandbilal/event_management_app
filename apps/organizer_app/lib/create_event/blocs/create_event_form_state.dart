// create_event_form_state.dart

import 'package:equatable/equatable.dart';

abstract class CreateEventFormState extends Equatable {
  const CreateEventFormState();

  @override
  List<Object?> get props => [];
}

// Initial state
class CreateEventFormNavigationInitial extends CreateEventFormState {}

// State for navigating to specific pages
class CreateEventFormNavigateToPage extends CreateEventFormState {
  final int pageIndex;

  const CreateEventFormNavigateToPage(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}

// Indicates successful form submission
class CreateEventFormSubmissionSuccess extends CreateEventFormState {}

// Indicates error during navigation
class CreateEventFormNavigationError extends CreateEventFormState {
  final String message;

  const CreateEventFormNavigationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Indicates error during form submission
class CreateEventFormSubmissionFailure extends CreateEventFormState {
  final String error;

  const CreateEventFormSubmissionFailure(this.error);

  @override
  List<Object?> get props => [error];
}
