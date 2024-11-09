import 'package:equatable/equatable.dart';

// Abstract base class for form events
abstract class CreateEventFormEvent extends Equatable {
  const CreateEventFormEvent();
}

// --- General Form Events ---

// Event to initialize a new draft event
class InitializeDraftEvent extends CreateEventFormEvent {
  final String brandId;
  final String createdByUserId;

  const InitializeDraftEvent({required this.brandId, required this.createdByUserId});

  @override
  List<Object?> get props => [brandId, createdByUserId];
}

// Event to update data from a form page
class UpdateFormPageData extends CreateEventFormEvent {
  final Map<String, dynamic> pageData;

  const UpdateFormPageData(this.pageData);

  @override
  List<Object?> get props => [pageData];
}

// Event to save the current draft form data
class SaveFormDraft extends CreateEventFormEvent {
  const SaveFormDraft();

  @override
  List<Object?> get props => [];
}

// Event to submit the form data and complete the process
class SubmitForm extends CreateEventFormEvent {
  const SubmitForm();

  @override
  List<Object?> get props => [];
}

// --- Image Management Events ---

// Event to update image URLs after an image upload or change
class UpdateImageUrls extends CreateEventFormEvent {
  final String fullImageUrl;
  final String croppedImageUrl;

  const UpdateImageUrls({required this.fullImageUrl, required this.croppedImageUrl});

  @override
  List<Object?> get props => [fullImageUrl, croppedImageUrl];
}

// Event to delete image URLs from the form state
class DeleteImageUrls extends CreateEventFormEvent {
  const DeleteImageUrls();

  @override
  List<Object?> get props => [];
}

// --- Event Details Events ---

// Event to update details on the details form page
class UpdateEventDetails extends CreateEventFormEvent {
  final Map<String, dynamic> eventData;

  const UpdateEventDetails(this.eventData);

  @override
  List<Object?> get props => [eventData];
}

// --- Ticketing Events ---

// Event for updating ticket details in the form
class UpdateTicketDetailsEvent extends CreateEventFormEvent {
  final Map<String, dynamic> ticketData;

  const UpdateTicketDetailsEvent(this.ticketData);

  @override
  List<Object?> get props => [ticketData];
}

// Event for toggling between free and paid tickets
class ToggleTicketTypeEvent extends CreateEventFormEvent {
  final bool isPaidTicket;

  const ToggleTicketTypeEvent(this.isPaidTicket);

  @override
  List<Object?> get props => [isPaidTicket];
}

// Event for saving the ticket details to the backend or database
class SaveTicketDetailsEvent extends CreateEventFormEvent {
  final String eventId;
  final Map<String, dynamic> ticketData;

  const SaveTicketDetailsEvent({required this.eventId, required this.ticketData});

  @override
  List<Object?> get props => [eventId, ticketData];
}
