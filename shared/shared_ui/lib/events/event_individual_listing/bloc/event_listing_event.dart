// event_listing_event.dart - updated with help

part of 'event_listing_bloc.dart';

abstract class EventListingEvent extends Equatable {
  const EventListingEvent();

  @override
  List<Object> get props => [];
}

// Event to load the event details by ID
class LoadEventListing extends EventListingEvent {
  final String eventId; // The ID of the event to fetch

  const LoadEventListing(this.eventId);

  @override
  List<Object> get props => [eventId];
}