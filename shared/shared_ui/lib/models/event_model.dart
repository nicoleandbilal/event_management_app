// event_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required String eventId,
    String? brandId,
    required String createdByUserId,
    required String eventName,
    required String description,
    required String category,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String venue,
    String? eventCoverImageFullUrl,
    String? eventCoverImageCroppedUrl,
    required String status, // pre-draft, draft, live, cancelled, past
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? saleStartDate,
    DateTime? saleEndDate,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
