import 'dart:io';
import 'package:shared/repositories/event_repository.dart';
import 'package:organizer_app/event_creation/event_cover_image/event_image_upload_service.dart';
import 'package:logger/logger.dart';

class BasicDetailsService {
  final EventRepository eventRepository;
  final ImageUploadService imageUploadService;
  final Logger logger;

  BasicDetailsService({
    required this.eventRepository,
    required this.imageUploadService,
    required this.logger,
  });

  /// Validates the basic details form data
  /// Throws a `BasicDetailsValidationException` if validation fails
void validateBasicDetails(
  Map<String, dynamic> formData, {
  bool skipValidation = false, // New parameter to skip validation
}) {
  if (skipValidation) {
    logger.i("Validation skipped for Basic Details.");
    return;
  }

  final missingFields = <String>[];

  if (formData['eventName'] == null || formData['eventName'].isEmpty) {
    missingFields.add('Event Name');
  }
  if (formData['startDateTime'] == null) {
    missingFields.add('Start Date & Time');
  }
  if (formData['endDateTime'] == null) {
    missingFields.add('End Date & Time');
  }
  if (formData['venue'] == null || formData['venue'].isEmpty) {
    missingFields.add('Venue');
  }

  if (missingFields.isNotEmpty) {
    throw BasicDetailsValidationException(missingFields);
  }
}

  /// Saves the basic details of the event draft
  Future<void> saveBasicDetails(
    String eventId,
    Map<String, dynamic> formData, {
    bool skipValidation = false, // New parameter to control validation
  }) async {
  validateBasicDetails(formData, skipValidation: skipValidation);

  try {
    logger.i("Saving basic details for event ID: $eventId");
    await eventRepository.updateDraftEvent(eventId, formData);
    logger.i("Basic details saved successfully for event ID: $eventId");
  } catch (e) {
    logger.e("Failed to save basic details for event ID: $eventId. Error: $e");
    throw BasicDetailsServiceException("Failed to save basic details.");
  }
}

  /// Uploads event images and returns the updated form data with image URLs
  Future<Map<String, dynamic>> uploadEventImages({
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
        'fullImageUrl': imageUrls['fullImageUrl'],
        'croppedImageUrl': imageUrls['croppedImageUrl'],
      };
    } catch (e) {
      logger.e("Failed to upload images for event ID: $eventId. Error: $e");
      throw BasicDetailsServiceException("Failed to upload images.");
    }
  }

  /// Deletes event cover images
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

      final event = await eventRepository.getEventDetails(eventId);
      if (event.eventName.isEmpty) {
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