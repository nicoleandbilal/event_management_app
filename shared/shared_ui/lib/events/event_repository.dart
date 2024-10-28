// event_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/event_model.dart';

class EventRepository {
  final FirebaseFirestore firestore;

  EventRepository({required this.firestore});

  // Fetch event details from Firestore using eventId
  Future<Event> getEventDetails(String eventId) async {
    try {
      // Retrieve event document by ID
      final DocumentSnapshot doc =
          await firestore.collection('events').doc(eventId).get();
      if (doc.exists) {
        // Convert the Firestore document into an Event model using fromDocument
        return Event.fromDocument(doc);
      } else {
        throw Exception('Event not found');
      }
    } catch (e) {
      throw Exception('Error fetching event details: $e');
    }
  }

  // Method for submitting (creating) an event
  Future<void> submitEvent(Event event) async {
    try {
      // Add a new event to Firestore collection
      await firestore.collection('events').add({
        'eventName': event.eventName,
        'description': event.description,
        'category': event.category,      // Added category field
        'startDateTime': Timestamp.fromDate(event.startDateTime),
        'endDateTime': Timestamp.fromDate(event.endDateTime),
        'venue': event.venue,
        'eventCoverImageFullUrl': event.eventCoverImageFullUrl,
        'eventCoverImageCroppedUrl': event.eventCoverImageCroppedUrl,
        'status': event.status,          // Add event status (e.g., live, draft, etc.)
        'createdAt': event.createdAt,    // Ensure createdAt is handled
        'updatedAt': event.updatedAt,    // Include updatedAt field if available
        'saleStartDate': event.saleStartDate,  // Ticket sale start time
        'saleEndDate': event.saleEndDate,      // Ticket sale end time
      });
    } catch (e) {
      throw Exception('Failed to submit event: $e');
    }
  }

  // Method to update an existing event
  Future<void> updateEvent(String eventId, Event event) async {
    try {
      // Update the event with new details in Firestore
      await firestore.collection('events').doc(eventId).update({
        'eventName': event.eventName,
        'description': event.description,
        'category': event.category,
        'startDateTime': Timestamp.fromDate(event.startDateTime),
        'endDateTime': Timestamp.fromDate(event.endDateTime),
        'venue': event.venue,
        'eventCoverImageFullUrl': event.eventCoverImageFullUrl,
        'eventCoverImageCroppedUrl': event.eventCoverImageCroppedUrl,
        'status': event.status,
        'updatedAt': Timestamp.now(),    // Update timestamp on modification
        'saleStartDate': event.saleStartDate,
        'saleEndDate': event.saleEndDate,
      });
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  // Method to delete an event by its eventId
  Future<void> deleteEvent(String eventId) async {
    try {
      // Delete the event document from Firestore
      await firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}
