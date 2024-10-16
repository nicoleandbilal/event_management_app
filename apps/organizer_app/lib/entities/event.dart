// lib/features/create_event/domain/entities/event.dart
import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String name;
  final String description;
  final String imageUrl;
  final DateTime startDateTime;
  final DateTime endDateTime;

  const Event({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.startDateTime,
    required this.endDateTime,
  });

  @override
  List<Object> get props => [name, description, imageUrl, startDateTime, endDateTime];
}
