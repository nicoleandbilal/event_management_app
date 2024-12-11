

import 'package:shared/models/event_model.dart';
import 'package:shared/repositories/event_repository.dart';

class EventCreationService {
  final EventRepository _eventRepository;

  EventCreationService(this._eventRepository, {required EventRepository eventRepository});

  /// Create a pre-draft event
  Future<Event> createPreDraftEvent(String createdByUserId) async {
    return await _eventRepository.createPreDraftEvent(createdByUserId: createdByUserId);
  }

  /// Update event status
  Future<void> updateEventStatus(String eventId, String status) async {
    await _eventRepository.updateEventFields(eventId, {'status': status});
  }

  /// Finalize event and mark it as live
  Future<void> finalizeEvent(Event event) async {
    final updatedEvent = event.copyWith(status: 'live', updatedAt: DateTime.now());
    await _eventRepository.saveEvent(updatedEvent);
  }
}