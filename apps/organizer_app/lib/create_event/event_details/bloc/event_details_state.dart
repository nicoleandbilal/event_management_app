// event_details_state.dart

import 'package:equatable/equatable.dart';

abstract class EventDetailsState extends Equatable {
  const EventDetailsState();

  @override
  List<Object?> get props => [];
}

// Initial state
class EventDetailsInitial extends EventDetailsState {}

// State for initialized draft event
class EventDraftInitialized extends EventDetailsState {
  final String eventId;

  const EventDraftInitialized(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

// State when event details are saved successfully
class EventDetailsSaved extends EventDetailsState {}

// Error state in event details
class EventDetailsFailure extends EventDetailsState {
  final String error;

  const EventDetailsFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// State for image uploading
class EventImageUploading extends EventDetailsState {}

// State for successful image upload
class EventImageUploadSuccess extends EventDetailsState {
  final String? fullImageUrl;
  final String? croppedImageUrl;

  const EventImageUploadSuccess(this.fullImageUrl, this.croppedImageUrl);

  @override
  List<Object?> get props => [fullImageUrl, croppedImageUrl];
}

// State for image deletion
class EventImageDeleting extends EventDetailsState {}

// State for successful image deletion
class EventImageDeleteSuccess extends EventDetailsState {}
