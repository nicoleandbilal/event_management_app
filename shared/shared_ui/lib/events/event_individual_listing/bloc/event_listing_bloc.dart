// event_listing_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/models/event_model.dart';
import 'package:shared/events/event_repository.dart';

// EventListingState
part 'event_listing_state.dart';
// EventListingEvent
part 'event_listing_event.dart';

class EventListingBloc extends Bloc<EventListingEvent, EventListingState> {
  final EventRepository eventRepository;

  EventListingBloc(this.eventRepository) : super(EventListingInitial()) {
    on<LoadEventListing>(_onLoadEventListing);
  }

  Future<void> _onLoadEventListing(
      LoadEventListing event, Emitter<EventListingState> emit) async {
    emit(EventListingLoading());  // Set loading state initially
    try {
      // Fetch the event data from the repository
      final eventData = await eventRepository.getEventDetails(event.eventId);
      emit(EventListingLoaded(eventData));  // Emit success with the event data
    } catch (error) {
      emit(EventListingError(error.toString()));  // Emit error if something fails
    }
  }
}
