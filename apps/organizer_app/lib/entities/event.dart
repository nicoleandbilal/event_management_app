// lib/entities/event.dart

import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String name;
  final String description;
  final String imageUrl;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String category;
  final String venue;

  const Event({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.startDateTime,
    required this.endDateTime,
    required this.category,
    required this.venue,
  });

  @override
  List<Object> get props => [name, description, imageUrl, startDateTime, endDateTime, category, venue];
}
