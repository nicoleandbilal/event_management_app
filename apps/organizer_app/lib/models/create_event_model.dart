// lib/models/create_event_model.dart

class CreateEvent {
  final String eventName;
  final String description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String category;
  final String venue;
  final String? imageUrl;

  CreateEvent({
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
  factory CreateEvent.fromJson(Map<String, dynamic> json) {
    return CreateEvent(
      eventName: json['name'],
      description: json['description'],
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
      category: json['category'],
      venue: json['venue'],
      imageUrl: json['imageUrl'],
    );
  }
}
