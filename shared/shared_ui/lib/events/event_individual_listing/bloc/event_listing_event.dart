// event_listing_event.dart

part of 'event_listing_bloc.dart';

abstract class EventListingEvent extends Equatable {
  const EventListingEvent();

  @override
  List<Object> get props => [];
}

class LoadEventListing extends EventListingEvent {
  final String eventId;

  const LoadEventListing(this.eventId);

  @override
  List<Object> get props => [eventId];
}
