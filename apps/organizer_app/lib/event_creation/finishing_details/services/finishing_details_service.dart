import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/finishing_details/models/finishing_details_mapper.dart';
import 'package:organizer_app/event_creation/finishing_details/models/finishing_details_model.dart';
import 'package:shared/models/event_model.dart';
import 'package:shared/repositories/event_repository.dart';

/// Service to handle Finishing Details logic
class FinishingDetailsService {
  final EventRepository _eventRepository;
  final Logger _logger;

  FinishingDetailsService({
    required EventRepository eventRepository,
    required Logger logger,
  })  : _eventRepository = eventRepository,
        _logger = logger;

  /// Load an existing Event by ID
  Future<Event?> loadEvent(String eventId) async {
    try {
      _logger.i("Loading event for event ID: $eventId");
      return await _eventRepository.getEvent(eventId);
    } catch (e) {
      _logger.e("Failed to load event for event ID: $eventId. Error: $e");
      throw Exception("Failed to load event.");
    }
  }

  /// Save Finishing Details to the shared Event model
  Future<void> saveFinishingDetails(FinishingDetailsModel finishingDetails, Event existingEvent) async {
    try {
      _logger.i("Saving finishing details for event ID: ${finishingDetails.eventId}");
      final updatedEvent = FinishingDetailsMapper.toEventModel(finishingDetails, existingEvent);
      await _eventRepository.saveEvent(updatedEvent);
      _logger.i("Finishing details saved successfully for event ID: ${finishingDetails.eventId}");
    } catch (e) {
      _logger.e("Failed to save finishing details for event ID: ${finishingDetails.eventId}. Error: $e");
      throw Exception("Failed to save finishing details.");
    }
  }

  /// Load Finishing Details from the shared Event model
  Future<FinishingDetailsModel?> loadFinishingDetails(String eventId) async {
    try {
      final event = await loadEvent(eventId);
      if (event == null) return null;
      return FinishingDetailsMapper.fromEventModel(event);
    } catch (e) {
      _logger.e("Failed to load finishing details for event ID: $eventId. Error: $e");
      throw Exception("Failed to load finishing details.");
    }
  }
}