// lib/models/create_event_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eventName;
  final String description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String category;
  final String venue;
  final String? imageUrl;

  Event({
    required this.eventName,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.category,
    required this.venue,
    this.imageUrl,
  });

  // Convert to JSON if needed for API request or storage
  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'description': description,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'category': category,
      'venue': venue,
      'imageUrl': imageUrl,
    };
  }

  // You can also implement fromJson if you're retrieving event data
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventName: json['eventName'],
      description: json['description'],
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
      category: json['category'],
      venue: json['venue'],
      imageUrl: json['imageUrl'],
    );
  }
  
 factory Event.fromDocument(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return Event(
    eventName: data['eventName'] ?? '',
    description: data['description'] ?? '',
    startDateTime: DateTime.parse(data['startDateTime']),
    endDateTime: DateTime.parse(data['endDateTime']),
    category: data['category'] ?? '',
    venue: data['venue'] ?? '',
    imageUrl: data['imageUrl'],
  );
}

}
