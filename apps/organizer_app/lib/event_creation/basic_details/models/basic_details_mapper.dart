import 'package:shared/models/event_model.dart';
import 'basic_details_model.dart';

class BasicDetailsMapper {
  /// Convert from shared model to form-specific model
  static BasicDetailsModel fromEventModel(Event event) {
    return BasicDetailsModel(
      eventId: event.eventId,
      eventName: event.eventName,
      description: event.description,
      category: event.category,
      venue: event.venue,
            startDateTime: event.startDateTime,
      endDateTime: event.endDateTime,
    );
  }

  /// Convert from form-specific model to shared model
  static Event toEventModel(BasicDetailsModel basicDetails, Event existingEvent) {
    return existingEvent.copyWith(
      eventName: basicDetails.eventName,
      description: basicDetails.description,
      category: basicDetails.category,
      venue: basicDetails.venue,
      startDateTime: basicDetails.startDateTime,
      endDateTime: basicDetails.endDateTime,
    );
  }
}