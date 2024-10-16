import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organizer_app/models/create_event_model.dart';

class CreateEventRepository {
  final FirebaseFirestore firestore;

  CreateEventRepository({required this.firestore});

  Future<void> submitEvent(CreateEvent event) async {
    try {
      await firestore.collection('events').add({
        'name': event.name,
        'description': event.description,
        'startDateTime' : event.startDateTime,
        'endDateTime' : event.endDateTime,
        'imageUrl' : event.imageUrl
        // Add other fields like startDate, endDate, etc.
      });
    } catch (e) {
      throw Exception('Failed to submit event: $e');
    }
  }
}
