import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/event_model.dart';
import 'package:shared/models/event_mapper.dart';

class EventRepository {
  final FirebaseFirestore firestore;
  final Logger _logger = Logger(); // Logger instance for tracking actions and errors

  EventRepository({required this.firestore});

  // Initialize a new event with "pre-draft" status; returns the generated event ID
  Future<String> initializeEventDraft(String userId) async {
    try {
      final newEventData = {
        'createdByUserId': userId,
        'status': 'pre-draft',
        'createdAt': Timestamp.now(),
        'updatedAt': null,
      };

      final docRef = await firestore
        .collection('events')
        .add(newEventData);
      _logger.i('Event draft initialized with pre-draft status. Event ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.e('Failed to initialize event draft: $e');
      throw Exception('Failed to initialize event draft: $e');
    }
  }

  // Update an existing event draft with new data, setting status to "draft"
  Future<void> updateDraftEvent(String eventId, Map<String, dynamic> updatedData) async {
    try {
      final draftData = {
        ..._sanitizeData(updatedData),
        'status': 'draft',
        'updatedAt': Timestamp.now(),
      };

      await firestore
        .collection('events')
        .doc(eventId)
        .update(draftData);
      _logger.i('Draft event updated with ID: $eventId');
    } catch (e) {
      _logger.e('Failed to update draft event $eventId: $e');
      throw Exception('Failed to update draft event: $e');
    }
  }

  // Publish an event, marking its status as "live" in Firestore
  Future<void> publishEvent(Event event) async {
    try {
      final eventData = {
        ...TomaEventMapper.toFirestore(event),
        'status': 'live',
        'updatedAt': Timestamp.now(),
      };

      await firestore
        .collection('events')
        .doc(event.eventId)
        .update(eventData);
      _logger.i('Event published successfully with ID: ${event.eventId}');
    } catch (e) {
      _logger.e('Failed to publish event ${event.eventId}: $e');
      throw Exception('Failed to publish event: $e');
    }
  }

  // Cancel an event by updating its status to "cancelled"
  Future<void> cancelEvent(String eventId) async {
    try {
      await firestore
        .collection('events')
        .doc(eventId)
        .update({
        'status': 'cancelled',
        'updatedAt': Timestamp.now(),
        });
      _logger.i('Event cancelled successfully with ID: $eventId');
    } catch (e) {
      _logger.e('Failed to cancel event $eventId: $e');
      throw Exception('Failed to cancel event: $e');
    }
  }

  // Fetch event details by ID, converting Firestore data to an Event model
  Future<Event> getEventDetails(String eventId) async {
    try {
      final doc = await firestore
        .collection('events')
        .doc(eventId)
        .get();
      if (doc.exists) {
        _logger.i('Fetched event details for ID: $eventId');
        return TomaEventMapper.fromFirestore(doc);
      } else {
        _logger.w('Event not found with ID: $eventId');
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
      final querySnapshot =
          await firestore
          .collection('events')
          .where('brandId', isEqualTo: brandId)
          .get();
      final events = querySnapshot.docs
        .map((doc) => TomaEventMapper.fromFirestore(doc))
        .toList();
      _logger.i('Fetched ${events.length} events for brand ID: $brandId');
      return events;
    } catch (e) {
      _logger.e('Error fetching events by brand ID $brandId: $e');
      throw Exception('Error fetching events by brand: $e');
    }
  }

  // Fetch events by status
  Future<List<Event>> getEventsByStatus(String status) async {
    try {
      final querySnapshot =
          await firestore
            .collection('events')
            .where('status', isEqualTo: status)
            .get();
      _logger.i('Fetched ${querySnapshot.docs.length} events with status: $status');
      return querySnapshot.docs
        .map((doc) => TomaEventMapper.fromFirestore(doc))
        .toList();
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
        for (var key in [
          'startDateTime',
          'endDateTime',
          'createdAt',
          'updatedAt',
          'saleStartDate',
          'saleEndDate'
        ]) {
          final value = data[key];
          if (value != null && value is! Timestamp) {
            _logger.d('Field "$key" in document ${doc.id} has type: ${data[key]?.runtimeType}');
          }
        }
      }

      final events = querySnapshot.docs
      .map((doc) => TomaEventMapper.fromFirestore(doc))
      .toList();
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
      var query = firestore
      .collection('events')
      .where('brandId', whereIn: brandIds);

      if (status != null) {
        query = query
        .where('status', isEqualTo: status);
      }

      final querySnapshot = await query.get();
      final events = querySnapshot.docs
      .map((doc) => TomaEventMapper.fromFirestore(doc))
      .toList();
      _logger.i('Fetched ${events.length} events for brand IDs: $brandIds with status: $status');
      return events;
    } catch (e) {
      _logger.e('Error fetching events for brands $brandIds with status $status: $e');
      throw Exception('Error fetching events for all user brands: $e');
    }
  }

  // Utility to sanitize and validate data before updating Firestore
  Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    final sanitizedData = Map<String, dynamic>.from(data);

    // Convert DateTime to Timestamp
    const dateFields = [
      'startDateTime', 
      'endDateTime', 
      'saleStartDate', 
      'saleEndDate', 
      'createdAt', 
      'updatedAt'];
    for (final field in dateFields) {
      if (sanitizedData[field] is DateTime) {
        sanitizedData[field] = Timestamp.fromDate(sanitizedData[field]);
      }
    }

    return sanitizedData;
  }
}
