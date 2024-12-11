import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/basic_details/models/basic_details_mapper.dart';
import 'package:organizer_app/event_creation/basic_details/models/basic_details_model.dart';
import 'package:shared/models/event_model.dart';
import 'package:shared/repositories/event_repository.dart';

/// Service to handle Basic Details logic
class BasicDetailsService {
  final EventRepository _eventRepository;
  final Logger _logger;

  BasicDetailsService({
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

  /// Save Basic Details to the shared Event model
  Future<void> saveBasicDetails(BasicDetailsModel basicDetails, Event existingEvent) async {
    try {
      _logger.i("Saving basic details for event ID: ${basicDetails.eventId}");
      final updatedEvent = BasicDetailsMapper.toEventModel(basicDetails, existingEvent);
      await _eventRepository.saveEvent(updatedEvent);
      _logger.i("Basic details saved successfully for event ID: ${basicDetails.eventId}");
    } catch (e) {
      _logger.e("Failed to save basic details for event ID: ${basicDetails.eventId}. Error: $e");
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
      _logger.e("Failed to load basic details for event ID: $eventId. Error: $e");
      throw Exception("Failed to load basic details.");
    }
  }
}