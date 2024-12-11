import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_model.dart';
import 'package:logger/logger.dart';

class TomaEventMapper {
  static final Logger _logger = Logger();

  /// Converts Firestore document to an Event model instance
  static Event fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;

      // Log types for date fields (optional debugging during development)
      _logger.d('startDateTime: ${data["startDateTime"]?.runtimeType} -> ${data["startDateTime"]}');
      _logger.d('endDateTime: ${data["endDateTime"]?.runtimeType} -> ${data["endDateTime"]}');

      return Event(
        eventId: doc.id,
        brandId: data['brandId'] as String?,
        createdByUserId: data['createdByUserId'] as String,
        eventName: data['eventName'] as String,
        description: data['description'] as String,
        category: data['category'] as String,
        startDateTime: (data['startDateTime'] as Timestamp).toDate(),
        endDateTime: (data['endDateTime'] as Timestamp).toDate(),
        venue: data['venue'] as String,
        eventCoverImageFullUrl: data['eventCoverImageFullUrl'] as String?,
        eventCoverImageCroppedUrl: data['eventCoverImageCroppedUrl'] as String?,
        status: data['status'] as String,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null,
        saleStartDate: data['saleStartDate'] != null ? (data['saleStartDate'] as Timestamp).toDate() : null,
        saleEndDate: data['saleEndDate'] != null ? (data['saleEndDate'] as Timestamp).toDate() : null,
      );
    } catch (e) {
      _logger.e("Error converting Firestore document to Event: $e");
      throw Exception("Error parsing Event document");
    }
  }

  /// Converts an Event model instance to Firestore-compatible JSON map
  static Map<String, dynamic> toFirestore(Event event) {
    return {
      'brandId': event.brandId,
      'createdByUserId': event.createdByUserId,
      'eventName': event.eventName,
      'description': event.description,
      'category': event.category,
      'startDateTime': Timestamp.fromDate(event.startDateTime),
      'endDateTime': Timestamp.fromDate(event.endDateTime),
      'venue': event.venue,
      'eventCoverImageFullUrl': event.eventCoverImageFullUrl,
      'eventCoverImageCroppedUrl': event.eventCoverImageCroppedUrl,
      'status': event.status,
      'createdAt': Timestamp.fromDate(event.createdAt),
      'updatedAt': event.updatedAt != null ? Timestamp.fromDate(event.updatedAt!) : null,
      'saleStartDate': event.saleStartDate != null ? Timestamp.fromDate(event.saleStartDate!) : null,
      'saleEndDate': event.saleEndDate != null ? Timestamp.fromDate(event.saleEndDate!) : null,
    };
  }
}