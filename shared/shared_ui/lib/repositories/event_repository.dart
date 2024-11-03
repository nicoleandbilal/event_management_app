import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/event_model.dart';

class EventRepository {
  final FirebaseFirestore firestore;

  EventRepository({required this.firestore});

  // Create a draft event with a "draft" status
  Future<String> createDraftEvent(Event event) async {
    try {
      final docRef = await firestore.collection('events').add({
        ...event.toJson(),
        'status': 'draft', // Ensure status is set to draft on creation
        'createdAt': Timestamp.now(),
        'updatedAt': null,
      });
      return docRef.id; // Return the Firestore-generated event ID
    } catch (e) {
      throw Exception('Failed to create draft event: $e');
    }
  }

  // Submit an event by updating its status to "live"
  Future<void> submitEvent(Event event) async {
    try {
      await firestore.collection('events').doc(event.eventId).update({
        ...event.toJson(),
        'status': 'live', // Update event status to live
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to submit event: $e');
    }
  }

  // Fetch event details from Firestore using eventId
  Future<Event> getEventDetails(String eventId) async {
    try {
      final DocumentSnapshot doc = await firestore.collection('events').doc(eventId).get();
      if (doc.exists) {
        return Event.fromDocument(doc); // Convert the Firestore document into an Event model
      } else {
        throw Exception('Event not found');
      }
    } catch (e) {
      throw Exception('Error fetching event details: $e');
    }
  }

  // Fetch events by brand ID to filter by specific brand
  Future<List<Event>> getEventsByBrand(String brandId) async {
    try {
      final querySnapshot = await firestore
          .collection('events')
          .where('brandId', isEqualTo: brandId)
          .get();

      return querySnapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching events by brand: $e');
    }
  }

  // Fetch events by status (e.g., "draft", "live") to filter by status
  Future<List<Event>> getEventsByStatus(String status) async {
    try {
      final querySnapshot = await firestore
          .collection('events')
          .where('status', isEqualTo: status)
          .get();

      return querySnapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching events by status: $e');
    }
  }

  // Fetch events by brand and status
  Future<List<Event>> getEventsByBrandAndStatus({
    required String brandId,
    required String? status,
  }) async {
    try {
      final querySnapshot = await firestore
          .collection('events')
          .where('brandId', isEqualTo: brandId)
          .where('status', isEqualTo: status)
          .get();

      return querySnapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching events by brand and status: $e');
    }
  }

// Fetch events across multiple brands with an optional status filter
  Future<List<Event>> getEventsForAllUserBrands(
      List<String> brandIds, String? status) async {
    try {
      var query = firestore.collection('events').where('brandId', whereIn: brandIds);
      
      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching events for all user brands: $e');
    }
  }
}