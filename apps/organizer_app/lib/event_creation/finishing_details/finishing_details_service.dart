import 'package:shared/repositories/event_repository.dart';

class FinishingDetailsService {
  final EventRepository eventRepository;

  FinishingDetailsService({required this.eventRepository});

  Future<void> saveFinishingDetails(String eventId, Map<String, dynamic> data) async {
    // Add specific logic for additional fields validation or transformation
    await eventRepository.updateDraftEvent(eventId, data);
  }

  Future<void> finalize(String eventId) async {
    // Any additional final checks before publishing
  }
}