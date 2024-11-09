import 'package:equatable/equatable.dart';
import 'package:shared/models/event_model.dart';

// Base state for all create event form states
abstract class CreateEventFormState extends Equatable {
  const CreateEventFormState();

  @override
  List<Object?> get props => [];
}

// Initial state of the form
class FormInitial extends CreateEventFormState {}

// General loading state for operations like saving or submitting
class FormLoading extends CreateEventFormState {}

// State when the draft form is initialized with an eventId
class FormDraftInitialized extends CreateEventFormState {
  final String eventId;

  const FormDraftInitialized(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

// State when the form draft has been updated
class FormDraftUpdated extends CreateEventFormState {
  final Event eventDraft;

  const FormDraftUpdated(this.eventDraft);

  @override
  List<Object?> get props => [eventDraft];
}

// State representing a successful form submission
class FormSuccess extends CreateEventFormState {}

// Failure state with an error message
class FormFailure extends CreateEventFormState {
  final String error;

  const FormFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// --- Event Details States ---

// State for updated event details in the form
class FormDetailsUpdated extends CreateEventFormState {
  final Map<String, dynamic> eventData;

  const FormDetailsUpdated(this.eventData);

  @override
  List<Object?> get props => [eventData];
}

// State for image uploading in the form
class FormImageUploading extends CreateEventFormState {}

// State when image URLs are successfully updated
class FormImageUrlsUpdated extends CreateEventFormState {
  final String? fullImageUrl;
  final String? croppedImageUrl;

  const FormImageUrlsUpdated({
    this.fullImageUrl,
    this.croppedImageUrl,
  });

  @override
  List<Object?> get props => [fullImageUrl, croppedImageUrl];
}

// --- Ticketing States ---

// Initial ticketing state for the form
class TicketingInitial extends CreateEventFormState {}

// Loading state for ticket details updates
class TicketingLoading extends CreateEventFormState {}

// State when ticket details are successfully updated
class TicketDetailsUpdated extends CreateEventFormState {
  final Map<String, dynamic> ticketData;

  const TicketDetailsUpdated(this.ticketData);

  @override
  List<Object?> get props => [ticketData];
}

// State indicating the ticket type has been toggled between free and paid
class TicketTypeToggled extends CreateEventFormState {
  final bool isPaidTicket;

  const TicketTypeToggled(this.isPaidTicket);

  @override
  List<Object?> get props => [isPaidTicket];
}

// State indicating successful saving of ticket details
class TicketDetailsSaved extends CreateEventFormState {}

// Failure state for ticketing operations
class TicketingFailure extends CreateEventFormState {
  final String error;

  const TicketingFailure(this.error);

  @override
  List<Object?> get props => [error];
}
