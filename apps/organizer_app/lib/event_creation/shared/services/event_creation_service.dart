

import 'package:shared/models/event_model.dart';
import 'package:shared/repositories/event_repository.dart';

class EventCreationService {
  final EventRepository _eventRepository;

  EventCreationService(this._eventRepository);

  Future<Event> createPreDraftEvent(String createdByUserId) async {
    return await _eventRepository.createPreDraftEvent(createdByUserId: createdByUserId);
  }

  Future<void> updateEventStatus(String eventId, String status) async {
    await _eventRepository.updateEventFields(eventId, {'status': status});
  }

  Future<void> finalizeEvent(Event event) async {
    final updatedEvent = event.copyWith(status: 'live', updatedAt: DateTime.now());
    await _eventRepository.saveEvent(updatedEvent);
  }
}