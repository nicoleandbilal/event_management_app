import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/event_mapper.dart';
import 'package:shared/models/event_model.dart';
import 'package:logger/logger.dart';

class EventRepository {
  final FirebaseFirestore firestore;
  final Logger _logger = Logger();

  EventRepository({required this.firestore});

  // Create a draft event with a "draft" status
  Future<String> createFormDraftEvent(Event event) async {
    try {
      _logger.d('Creating draft event with data: ${event.toJson()}');
      final docRef = await firestore.collection('events').add({
        ...TomaEventMapper.toFirestore(event),
        'status': 'draft',
        'createdAt': Timestamp.now(),
        'updatedAt': null,
      });
      _logger.i('Draft event created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.e('Failed to create draft event: $e');
      throw Exception('Failed to create draft event: $e');
    }
  }

  // Updates a draft event with partial data and sets status to 'draft'
  Future<void> updateDraftEvent(String eventId, Map<String, dynamic> updatedData) async {
    try {
      _logger.d('Updating draft event $eventId with data: $updatedData');
      updatedData['status'] = 'draft';
      updatedData['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await firestore.collection('events').doc(eventId).update(updatedData);
      _logger.i('Draft event $eventId updated successfully');
    } catch (e) {
      _logger.e('Failed to update draft event $eventId: $e');
      throw Exception('Failed to update draft event: $e');
    }
  }

  // Submit an event by updating its status to "live"
  Future<void> submitEvent(Event event) async {
    try {
      _logger.d('Submitting event with ID: ${event.eventId} and data: ${event.toJson()}');
      await firestore.collection('events').doc(event.eventId).update({
        ...TomaEventMapper.toFirestore(event),
        'status': 'live',
        'updatedAt': Timestamp.now(),
      });
      _logger.i('Event ${event.eventId} submitted successfully');
    } catch (e) {
      _logger.e('Failed to submit event ${event.eventId}: $e');
      throw Exception('Failed to submit event: $e');
    }
  }

  // Fetch event details from Firestore using eventId
  Future<Event> getEventDetails(String eventId) async {
    try {
      _logger.d('Fetching event details for ID: $eventId');
      final DocumentSnapshot doc = await firestore.collection('events').doc(eventId).get();
      if (doc.exists) {
        final event = TomaEventMapper.fromFirestore(doc);
        _logger.i('Event details fetched successfully for ID: $eventId');
        return event;
      } else {
        _logger.w('Event not found for ID: $eventId');
        throw Exception('Event not found');
      }
    } catch (e) {
      _logger.e('Error fetching event details for ID $eventId: $e');
      throw Exception('Error fetching event details: $e');
    }
  }

  // Fetch events by brand ID
  Future<List<Event>> getEventsByBrand(String brandId) async {
    try {
      _logger.d('Fetching events for brand ID: $brandId');
      final querySnapshot = await firestore.collection('events').where('brandId', isEqualTo: brandId).get();
      final events = querySnapshot.docs.map((doc) => TomaEventMapper.fromFirestore(doc)).toList();
      _logger.i('Fetched ${events.length} events for brand ID: $brandId');
      return events;
    } catch (e) {
      _logger.e('Error fetching events by brand ID $brandId: $e');
      throw Exception('Error fetching events by brand: $e');
    }
  }

  // Fetch events by status (e.g., "draft", "live")
  Future<List<Event>> getEventsByStatus(String status) async {
    try {
      _logger.d('Fetching events with status: $status');
      final querySnapshot = await firestore.collection('events').where('status', isEqualTo: status).get();
      final events = querySnapshot.docs.map((doc) => TomaEventMapper.fromFirestore(doc)).toList();
      _logger.i('Fetched ${events.length} events with status: $status');
      return events;
    } catch (e) {
      _logger.e('Error fetching events with status $status: $e');
      throw Exception('Error fetching events by status: $e');
    }
  }

  // Fetch events by brand and status with detailed logging of potential type issues
  Future<List<Event>> getEventsByBrandAndStatus({
    required String brandId,
    required String? status,
  }) async {
    try {
      _logger.d('Fetching events for brandId: $brandId with status: $status');
      final querySnapshot = await firestore
          .collection('events')
          .where('brandId', isEqualTo: brandId)
          .where('status', isEqualTo: status)
          .get();

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        for (var key in ['startDateTime', 'endDateTime', 'createdAt', 'updatedAt', 'saleStartDate', 'saleEndDate']) {
          final value = data[key];
          if (value != null && value is! Timestamp) {
          _logger.d('Field "$key" in document ${doc.id} has type: ${data[key]?.runtimeType}');
          }
        }
      }

      final events = querySnapshot.docs.map((doc) => TomaEventMapper.fromFirestore(doc)).toList();
      _logger.i('Fetched ${events.length} events for brandId: $brandId with status: $status');
      return events;

    } catch (e, stackTrace) {
      _logger.e('Error fetching events by brand and status: $e', error: e, stackTrace: stackTrace);
      throw Exception('Error fetching events by brand and status: $e');
    }
  }

  // Fetch events across multiple brands with optional status filter
  Future<List<Event>> getEventsForAllUserBrands(List<String> brandIds, String? status) async {
    try {
      _logger.d('Fetching events for brand IDs: $brandIds with status: $status');
      var query = firestore.collection('events').where('brandId', whereIn: brandIds);
      
      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      final querySnapshot = await query.get();
      final events = querySnapshot.docs.map((doc) => TomaEventMapper.fromFirestore(doc)).toList();
      _logger.i('Fetched ${events.length} events for brand IDs: $brandIds with status: $status');
      return events;
    } catch (e) {
      _logger.e('Error fetching events for brands $brandIds with status $status: $e');
      throw Exception('Error fetching events for all user brands: $e');
    }
  }
}
