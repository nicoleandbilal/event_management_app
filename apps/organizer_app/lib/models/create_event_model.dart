class CreateEvent {
  final String name;
  final String description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String? imageUrl;

  CreateEvent({
    required this.name,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    this.imageUrl,
  });

  // Convert to JSON if needed for API request or storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  // You can also implement fromJson if you're retrieving event data
  factory CreateEvent.fromJson(Map<String, dynamic> json) {
    return CreateEvent(
      name: json['name'],
      description: json['description'],
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
      imageUrl: json['imageUrl'],
    );
  }
}
