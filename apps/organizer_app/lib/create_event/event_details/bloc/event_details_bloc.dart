// event_details_bloc.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_event/event_details/bloc/event_details_event.dart';
import 'package:organizer_app/create_event/event_details/bloc/event_details_state.dart';
import 'package:shared/models/event_model.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/image_repository.dart';

class EventDetailsBloc extends Bloc<EventDetailsEvent, EventDetailsState> {
  final EventRepository eventRepository;
  final ImageRepository imageRepository;
  Event? draftEvent;

  EventDetailsBloc({
    required this.eventRepository,
    required this.imageRepository,
  }) : super(EventDetailsInitial()) {
    on<InitializeDraftEvent>(_onInitializeDraftEvent);
    on<SaveEventDetailsEvent>(_onSaveEventDetailsEvent);
    on<UploadEventImageEvent>(_onUploadEventImageEvent);
    on<DeleteEventImageEvent>(_onDeleteEventImageEvent);
  }

  // Initializes a draft event
  Future<void> _onInitializeDraftEvent(
      InitializeDraftEvent event, Emitter<EventDetailsState> emit) async {
    try {
      draftEvent = Event(
        eventId: '',
        brandId: event.brandId,
        createdByUserId: event.createdByUserId,
        eventName: '',
        description: '',
        category: 'Other',
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(const Duration(hours: 1)),
        venue: '',
        status: 'draft',
        createdAt: DateTime.now(),
      );

      final eventId = await eventRepository.createFormDraftEvent(draftEvent!);
      draftEvent = draftEvent!.copyWith(eventId: eventId);
      emit(EventDraftInitialized(eventId));
    } catch (e) {
      emit(EventDetailsFailure('Failed to initialize draft event: $e'));
    }
  }

  // Saves event details after validation
  Future<void> _onSaveEventDetailsEvent(
      SaveEventDetailsEvent event, Emitter<EventDetailsState> emit) async {
    if (draftEvent != null) {
      draftEvent = draftEvent!.copyWith(
        eventName: event.eventData['eventName'],
        description: event.eventData['description'],
        category: event.eventData['category'],
        venue: event.eventData['venue'],
        startDateTime: event.eventData['startDateTime'],
        endDateTime: event.eventData['endDateTime'],
      );

      try {
        await eventRepository.updateDraftEvent(draftEvent!.eventId, draftEvent!.toJson());
        emit(EventDetailsSaved());
      } catch (e) {
        emit(EventDetailsFailure("Failed to save event details: $e"));
      }
    }
  }

  // Handles image upload for event cover
  Future<void> _onUploadEventImageEvent(
      UploadEventImageEvent event, Emitter<EventDetailsState> emit) async {
    emit(EventImageUploading());
    try {
      final imageUrls = await imageRepository.uploadFullAndCroppedImages(
        event.fullImage,
        event.croppedImage,
        draftEvent?.eventId ?? '',
      );
      draftEvent = draftEvent?.copyWith(
        eventCoverImageFullUrl: imageUrls['fullImageUrl'],
        eventCoverImageCroppedUrl: imageUrls['croppedImageUrl'],
      );
      emit(EventImageUploadSuccess(imageUrls['fullImageUrl'], imageUrls['croppedImageUrl']));
    } catch (e) {
      emit(EventDetailsFailure("Failed to upload event image: $e"));
    }
  }

  // Handles image deletion for event cover
  Future<void> _onDeleteEventImageEvent(
      DeleteEventImageEvent event, Emitter<EventDetailsState> emit) async {
    emit(EventImageDeleting());
    try {
      await imageRepository.deleteEventImages(draftEvent?.eventId ?? '');
      draftEvent = draftEvent?.copyWith(
        eventCoverImageFullUrl: null,
        eventCoverImageCroppedUrl: null,
      );
      emit(EventImageDeleteSuccess());
    } catch (e) {
      emit(EventDetailsFailure("Failed to delete event image: $e"));
    }
  }
}
