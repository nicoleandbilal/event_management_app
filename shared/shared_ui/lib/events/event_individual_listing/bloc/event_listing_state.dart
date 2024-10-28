// lib/blocs/event_listing/event_listing_state.dart

part of 'event_listing_bloc.dart';

abstract class EventListingState extends Equatable {
  const EventListingState();

  @override
  List<Object?> get props => [];
}

// Initial state when the listing is not yet loaded
class EventListingInitial extends EventListingState {}

// Loading state while fetching the event data
class EventListingLoading extends EventListingState {}

// Loaded state when event data is successfully fetched
class EventListingLoaded extends EventListingState {
  final Event event;  // Contains the event data

  const EventListingLoaded(this.event);

  @override
  List<Object?> get props => [event];
}

// Error state if fetching the event data fails
class EventListingError extends EventListingState {
  final String error;

  const EventListingError(this.error);

  @override
  List<Object?> get props => [error];
}
