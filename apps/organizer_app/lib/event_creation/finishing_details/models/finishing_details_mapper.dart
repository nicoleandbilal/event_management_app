import 'package:shared/models/event_model.dart';
import 'finishing_details_model.dart';

class FinishingDetailsMapper {
  /// Convert shared `Event` model to `FinishingDetailsModel`.
  static FinishingDetailsModel fromEventModel(Event event) {
    return FinishingDetailsModel(
      eventId: event.eventId,
      salesStartDate: event.saleStartDate,
      salesEndDate: event.saleEndDate,
      privacyPolicyAgreed: false, // Assume false if not specified in the Event.
      remarks: null, // Event doesn't include remarks directly.
    );
  }

  /// Convert `FinishingDetailsModel` back to shared `Event` model.
  static Event toEventModel(FinishingDetailsModel finishingDetails, Event existingEvent) {
    return existingEvent.copyWith(
      saleStartDate: finishingDetails.salesStartDate,
      saleEndDate: finishingDetails.salesEndDate,
    );
  }
}