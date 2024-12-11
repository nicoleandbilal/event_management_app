import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/event_mapper.dart';
import '../models/event_model.dart';

class EventRepository {
  final FirebaseFirestore _firestore;
    final Logger _logger = Logger();

  EventRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  /// Create or overwrite an event document
  Future<void> saveEvent(Event event) async {
    try {
      await _firestore
          .collection('events')
          .doc(event.eventId)
          .set(TomaEventMapper.toFirestore(event), SetOptions(merge: true));
    } catch (e) {
      throw Exception("Error saving event: $e");
    }
  }

  /// Fetch an event by its ID
  Future<Event?> getEvent(String eventId) async {
    try {
      final doc = await _firestore.collection('events').doc(eventId).get();
      if (!doc.exists) return null;
      return TomaEventMapper.fromFirestore(doc);
    } catch (e) {
      throw Exception("Error fetching event: $e");
    }
  }

  /// Update specific fields in an event document
  Future<void> updateEventFields(
      String eventId, Map<String, dynamic> updatedFields) async {
    try {
      await _firestore
          .collection('events')
          .doc(eventId)
          .update(updatedFields);
    } catch (e) {
      if (e is FirebaseException && e.code == 'not-found') {
        throw Exception('Event not found for ID: $eventId');
      } else {
        throw Exception("Error updating event: $e");
      }
    }
  }

  /// Create a pre-draft event when the modal opens
  Future<Event> createPreDraftEvent({
    required String createdByUserId,
  }) async {
    try {
      final eventId = _firestore.collection('events').doc().id; // Generate unique ID
      final event = Event(
        eventId: eventId,
        brandId: null,
        createdByUserId: createdByUserId,
        eventName: '',
        description: '',
        category: '',
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(const Duration(hours: 2)),
        venue: '',
        eventCoverImageFullUrl: null,
        eventCoverImageCroppedUrl: null,
        status: 'pre-draft',
        createdAt: DateTime.now(),
      );
      await saveEvent(event);
      return event;
    } catch (e) {
      throw Exception("Error creating pre-draft event: $e");
    }
  }


  /// Fetch events by brand ID
  Future<List<Event>> getEventsByBrand(String brandId) async {
    try {
      final querySnapshot = await _firestore
          .collection('events')
          .where('brandId', isEqualTo: brandId)
          .get();
      return querySnapshot.docs
          .map((doc) => TomaEventMapper.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching events by brand: $e');
    }
  }

  /// Fetch events by status (e.g., "draft", "live")
  Future<List<Event>> getEventsByStatus(String status) async {
    // Validate the input status
    if (status.isEmpty) {
      throw Exception('Status cannot be empty.');
    }

    try {
      // Log the query for debugging purposes
      _logger.d('Fetching events with status: $status');

      // Query Firestore for events with the given status
      final querySnapshot = await _firestore
          .collection('events')
          .where('status', isEqualTo: status)
          .get();

      // Map Firestore documents to Event objects
      final events = querySnapshot.docs
          .map((doc) => TomaEventMapper.fromFirestore(doc))
          .toList();

      _logger.d('Fetched ${events.length} events with status: $status');
      return events;
    } catch (e) {
      // Log and rethrow the error with a descriptive message
      _logger.e('Error fetching events by status: $e');
      throw Exception('Error fetching events by status: $e');
    }
  }

  /// Fetch events by brand and status with detailed logging
  Future<List<Event>> getEventsByBrandAndStatus({
    required String brandId,
    required String? status,
  }) async {
    try {
      final query = _firestore.collection('events').where('brandId', isEqualTo: brandId);

      final querySnapshot = status != null
          ? await query.where('status', isEqualTo: status).get()
          : await query.get();

      return querySnapshot.docs
          .map((doc) => TomaEventMapper.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching events by brand and status: $e');
    }
  }

  /// Fetch events across multiple brands with optional status filter
  Future<List<Event>> getEventsForAllUserBrands(
      List<String> brandIds, String? status) async {
    // Check for empty brand IDs
    if (brandIds.isEmpty) {
      throw Exception('Brand IDs cannot be empty.');
    }

    try {
      // Firestore whereIn query limit is 10, split the list if necessary
      List<Event> events = [];
      final chunks = _splitList(brandIds, 10);

      for (var chunk in chunks) {
        var query = _firestore
            .collection('events')
            .where('brandId', whereIn: chunk);

        if (status != null) {
          query = query.where('status', isEqualTo: status);
        }

        final querySnapshot = await query.get();
        events.addAll(querySnapshot.docs
            .map((doc) => TomaEventMapper.fromFirestore(doc))
            .toList());
      }

      return events;
    } catch (e) {
      if (e.toString().contains('whereIn')) {
        throw Exception('Error: Firestore whereIn query failed. Limit is 10 items.');
      }
      throw Exception('Error fetching events for all user brands: $e');
    }
  }

  /// Utility function to split a list into chunks of a specified size
  List<List<T>> _splitList<T>(List<T> list, int chunkSize) {
    return List.generate(
      (list.length / chunkSize).ceil(),
      (i) => list.sublist(
        i * chunkSize,
        (i * chunkSize + chunkSize).clamp(0, list.length),
      ),
    );
  }

}