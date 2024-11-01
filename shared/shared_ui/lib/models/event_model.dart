import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eventId;
  final String? brandId; // Foreign key to relate to the Brand
  final String eventName;
  final String description;
  final String category;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String venue;
  final String? eventCoverImageFullUrl;
  final String? eventCoverImageCroppedUrl;
  final String? status; // e.g., draft, live, past, canceled
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final Timestamp? saleStartDate; // When ticket sales start
  final Timestamp? saleEndDate; // When ticket sales end

  Event({
    required this.eventId,
    required this.brandId,
    required this.eventName,
    required this.description,
    required this.category,
    required this.startDateTime,
    required this.endDateTime,
    required this.venue,
    this.eventCoverImageFullUrl,
    this.eventCoverImageCroppedUrl,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.saleStartDate,
    this.saleEndDate,
  });

  // Convert Firestore document to Event model
  factory Event.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      eventId: doc.id,
      brandId: data['brandId'],
      eventName: data['eventName'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      startDateTime: (data['startDateTime'] as Timestamp).toDate(),
      endDateTime: (data['endDateTime'] as Timestamp).toDate(),
      venue: data['venue'] ?? '',
      eventCoverImageFullUrl: data['eventCoverImageFullUrl'],
      eventCoverImageCroppedUrl: data['eventCoverImageCroppedUrl'],
      status: data['status'] ?? 'draft',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
      saleStartDate: data['saleStartDate'],
      saleEndDate: data['saleEndDate'],
    );
  }

  // Convert Event model to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'brandId': brandId,
      'eventName': eventName,
      'description': description,
      'category': category,
      'startDateTime': Timestamp.fromDate(startDateTime),
      'endDateTime': Timestamp.fromDate(endDateTime),
      'venue': venue,
      'eventCoverImageFullUrl': eventCoverImageFullUrl,
      'eventCoverImageCroppedUrl': eventCoverImageCroppedUrl,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'saleStartDate': saleStartDate,
      'saleEndDate': saleEndDate,
    };
  }
}
