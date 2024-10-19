// lib/repositories/create_event_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/event_model.dart';

class CreateEventRepository {
  final FirebaseFirestore firestore;

  CreateEventRepository({required this.firestore});

  Future<void> submitEvent(Event event) async {
  try {
    await firestore.collection('events').add({
      'eventName': event.eventName,
      'description': event.description,
      'startDateTime': event.startDateTime,
      'endDateTime': event.endDateTime,
      'category': event.category, // Add category and venue here
      'venue': event.venue,
      'imageUrl': event.imageUrl,
    });
  } catch (e) {
    throw Exception('Failed to submit event: $e');
  }
}

}

