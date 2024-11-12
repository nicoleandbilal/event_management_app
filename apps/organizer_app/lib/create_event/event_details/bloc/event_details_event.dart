// event_details_event.dart

import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class EventDetailsEvent extends Equatable {
  const EventDetailsEvent();

  @override
  List<Object?> get props => [];
}

// Initialize a new draft event
class InitializeDraftEvent extends EventDetailsEvent {
  final String brandId;
  final String createdByUserId;

  const InitializeDraftEvent({required this.brandId, required this.createdByUserId});
}

// Save event details
class SaveEventDetailsEvent extends EventDetailsEvent {
  final Map<String, dynamic> eventData;

  const SaveEventDetailsEvent(this.eventData);

  @override
  List<Object?> get props => [eventData];
}

// Upload full and cropped event images
class UploadEventImageEvent extends EventDetailsEvent {
  final File fullImage;
  final File croppedImage;

  const UploadEventImageEvent({required this.fullImage, required this.croppedImage});

  @override
  List<Object?> get props => [fullImage, croppedImage];
}

// Delete event images
class DeleteEventImageEvent extends EventDetailsEvent {}
