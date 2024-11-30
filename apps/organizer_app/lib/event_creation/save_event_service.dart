import 'package:collection/collection.dart';
import 'package:organizer_app/event_creation/basic_details/basic_details_service.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_event.dart';
import 'package:organizer_app/event_creation/ticket_details/ticket_details_service.dart';
import 'package:organizer_app/event_creation/finishing_details/finishing_details_service.dart';
import 'package:logger/logger.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/ticket_repository.dart';

class SaveEventService {
  final BasicDetailsService basicDetailsService;
  final TicketDetailsService ticketDetailsService;
  final FinishingDetailsService finishingDetailsService;
  final EventRepository eventRepository;
  final TicketRepository ticketRepository;
  final Logger logger;

  final Map<EventStep, Map<String, dynamic>> _lastSavedData = {};

  SaveEventService({
    required this.basicDetailsService,
    required this.ticketDetailsService,
    required this.finishingDetailsService,
    required this.eventRepository,
    required this.ticketRepository,
    required this.logger,
  });

  Future<void> saveStepData({
    required String eventId,
    required EventStep step,
    required Map<String, dynamic> updatedData,
    bool isPublishing = false,
  }) async {
    if (_isDataUnchanged(step, updatedData)) {
      logger.i("No changes detected for step $step. Skipping save.");
      return;
    }

    if (!isPublishing) {
      logger.i("Skipping validation for intermediate save.");
    } else {
      _validateStepData(step, updatedData, isPublishing: true);
    }

    try {
      switch (step) {
        case EventStep.BasicDetails:
          updatedData['eventName'] ??= 'Untitled Event';
          updatedData['startDateTime'] ??= DateTime.now();
          updatedData['endDateTime'] ??= DateTime.now().add(const Duration(hours: 1));
          updatedData['venue'] ??= 'No Venue Specified';

          logger.i("Saving Basic Details for event ID: $eventId");
          await basicDetailsService.saveBasicDetails(eventId, updatedData);
          break;
        case EventStep.TicketDetails:
          logger.i("Saving Ticket Details for event ID: $eventId");
          final ticketList = updatedData['tickets'] as List<Map<String, dynamic>>;
          await ticketDetailsService.saveTickets(eventId, ticketList);
          break;
        case EventStep.FurtherDetails:
          logger.i("Saving Finishing Details for event ID: $eventId");
          await finishingDetailsService.saveFinishingDetails(eventId, updatedData);
          break;
        default:
          throw Exception("Invalid step for saving data.");
      }

      _lastSavedData[step] = Map<String, dynamic>.from(updatedData);
      logger.i("Data saved successfully for step: $step");
    } catch (e) {
      logger.e("Failed to save data for step: $step. Error: $e");
      throw Exception("Failed to save data for step: $step.");
    }
  }

  Future<void> publishEvent(String eventId) async {
    try {
      logger.i("Publishing event with ID: $eventId");
      final event = await eventRepository.getEventDetails(eventId);
      _validatePublishData(event);

      await eventRepository.publishEvent(event);
      logger.i("Event published successfully: $eventId");
    } catch (e) {
      logger.e("Failed to publish event ID: $eventId. Error: $e");
      throw Exception("Failed to publish the event. Please try again.");
    }
  }

  bool _isDataUnchanged(EventStep step, Map<String, dynamic> updatedData) {
    final lastData = _lastSavedData[step];
    if (lastData == null) return false;
    return const MapEquality().equals(lastData, updatedData);
  }

  void _validateStepData(EventStep step, Map<String, dynamic> updatedData, {bool isPublishing = false}) {
    final requiredFields = {
      EventStep.BasicDetails: ['eventName', 'startDateTime', 'endDateTime', 'venue'],
      EventStep.TicketDetails: ['tickets'],
    };

    if (isPublishing) {
      final stepRequiredFields = requiredFields[step] ?? [];
      final missingFields = stepRequiredFields
          .where((field) => updatedData[field] == null || updatedData[field].toString().isEmpty)
          .toList();

      if (missingFields.isNotEmpty) {
        throw Exception("Missing Fields: ${missingFields.join(', ')}");
      }
    }
  }

  void _validatePublishData(dynamic event) {
    if (event.eventName.isEmpty) {
      throw Exception("Event name cannot be empty for publishing.");
    }
    if (event.startDateTime == null || event.endDateTime == null) {
      throw Exception("Event must have a valid start and end date.");
    }
    if (event.venue.isEmpty) {
      throw Exception("Event must have a valid venue.");
    }
  }
}