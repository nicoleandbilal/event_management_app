import 'dart:io';

import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/services/event_image_uploader_service.dart';
import 'package:organizer_app/event_creation/basic_details/models/basic_details_mapper.dart';
import 'package:organizer_app/event_creation/basic_details/models/basic_details_model.dart';
import 'package:shared/models/event_model.dart';
import 'package:shared/repositories/event_repository.dart';

class BasicDetailsService {
  final EventRepository eventRepository;
  final ImageUploadService imageUploadService;
  final Logger logger;

  BasicDetailsService({
    required this.eventRepository,
    required this.imageUploadService,
    required this.logger,
  });

  /// Load an existing Event by ID
  Future<Event?> loadEvent(String eventId) async {
    try {
      logger.i("Loading event for event ID: $eventId");
      return await eventRepository.getEvent(eventId);
    } catch (e) {
      logger.e("Failed to load event for event ID: $eventId. Error: $e");
      throw Exception("Failed to load event.");
    }
  }

  /// Save Basic Details to the shared Event model
  Future<void> saveBasicDetails(BasicDetailsModel basicDetails, Event existingEvent) async {
    try {
      logger.i("Saving basic details for event ID: ${basicDetails.eventId}");
      final updatedEvent = BasicDetailsMapper.toEventModel(basicDetails, existingEvent);
      await eventRepository.saveEvent(updatedEvent);
      logger.i("Basic details saved successfully for event ID: ${basicDetails.eventId}");
    } catch (e) {
      logger.e("Failed to save basic details for event ID: ${basicDetails.eventId}. Error: $e");
      throw Exception("Failed to save basic details.");
    }
  }

  /// Load Basic Details from the shared Event model
  Future<BasicDetailsModel?> loadBasicDetails(String eventId) async {
    try {
      final event = await loadEvent(eventId);
      if (event == null) return null;
      return BasicDetailsMapper.fromEventModel(event);
    } catch (e) {
      logger.e("Failed to load basic details for event ID: $eventId. Error: $e");
      throw Exception("Failed to load basic details.");
    }
  }

  /// Uploads event images through the ImageUploadService and returns the URLs
  Future<Map<String, String>> uploadEventImages({
    required String eventId,
    required File fullImage,
    required File croppedImage,
  }) async {
    try {
      logger.i("Uploading images for event ID: $eventId");

      final imageUrls = await imageUploadService.uploadFullAndCroppedImages(
        fullImage,
        croppedImage,
        eventId,
      );

      logger.i("Images uploaded successfully for event ID: $eventId");
      return {
        'fullImageUrl': imageUrls['fullImageUrl']!,
        'croppedImageUrl': imageUrls['croppedImageUrl']!,
      };
    } catch (e) {
      logger.e("Failed to upload images for event ID: $eventId. Error: $e");
      throw BasicDetailsServiceException("Failed to upload images.");
    }
  }

  /// Deletes event images through the ImageUploadService
  Future<void> deleteEventImages(String eventId) async {
    try {
      logger.i("Deleting images for event ID: $eventId");
      await imageUploadService.deleteEventCoverImages(eventId);
      logger.i("Images deleted successfully for event ID: $eventId");
    } catch (e) {
      logger.e("Failed to delete images for event ID: $eventId. Error: $e");
      throw BasicDetailsServiceException("Failed to delete images.");
    }
  }

  /// Validates and finalizes the basic details step
  Future<void> finalizeBasicDetails(String eventId) async {
    try {
      logger.i("Finalizing basic details for event ID: $eventId");

      final event = await eventRepository.getEvent(eventId);
      if (event == null || event.eventName.isEmpty) {
        throw BasicDetailsServiceException("Event name is required for publishing.");
      }

      logger.i("Basic details finalized successfully for event ID: $eventId");
    } catch (e) {
      logger.e("Failed to finalize basic details for event ID: $eventId. Error: $e");
      throw BasicDetailsServiceException("Failed to finalize basic details.");
    }
  }
}

class BasicDetailsValidationException implements Exception {
  final List<String> missingFields;

  BasicDetailsValidationException(this.missingFields);

  @override
  String toString() => "Missing Fields: ${missingFields.join(', ')}";
}

class BasicDetailsServiceException implements Exception {
  final String message;

  BasicDetailsServiceException(this.message);

  @override
  String toString() => "BasicDetailsServiceException: $message";
}