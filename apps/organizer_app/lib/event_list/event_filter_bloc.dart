import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/models/event_model.dart';

part 'event_filter_event.dart';
part 'event_filter_state.dart';

class EventFilterBloc extends Bloc<EventFilterEvent, EventFilterState> {
  final EventRepository eventRepository;

  EventFilterBloc({required this.eventRepository}) : super(EventFilterInitial()) {
    on<FilterEvents>(_onFilterEvents);
  }

  Future<void> _onFilterEvents(FilterEvents event, Emitter<EventFilterState> emit) async {
    emit(EventFilterLoading());

    try {
      List<Event> events;

      if (event.brandIds.length > 1) {
        // "All" brands selected, fetch events across all user's brands
        events = await eventRepository.getEventsForAllUserBrands(event.brandIds, event.status);
      } else {
        // Filter by a single brandId and status
        events = await eventRepository.getEventsByBrandAndStatus(
          brandId: event.brandIds.first,
          status: event.status,
        );
      }

      emit(EventFilterLoaded(filteredEvents: events));
    } catch (e) {
      emit(EventFilterError(errorMessage: 'Failed to load events: $e'));
    }
  }
}
