import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/models/event_model.dart';
import 'package:logger/logger.dart';

part 'event_filter_event.dart';
part 'event_filter_state.dart';

class EventFilterBloc extends Bloc<EventFilterEvent, EventFilterState> {
  final EventRepository eventRepository;
  final Logger _logger = Logger();

  EventFilterBloc({required this.eventRepository}) : super(EventFilterInitial()) {
    on<FilterEvents>(_onFilterEvents);
  }

  Future<void> _onFilterEvents(FilterEvents event, Emitter<EventFilterState> emit) async {
    emit(EventFilterLoading());
    
    try {
      List<Event> events;
      _logger.d('Starting to fetch events for brandIds: ${event.brandIds} with status: ${event.status}');
      
      if (event.brandIds.length > 1) {
        // Fetch events for multiple brands
        events = await eventRepository.getEventsForAllUserBrands(event.brandIds, event.status);
      } else {
        // Fetch events for a single brand
        events = await eventRepository.getEventsByBrandAndStatus(
          brandId: event.brandIds.first,
          status: event.status,
        );
      }

      _logger.d('Events fetched successfully. Count: ${events.length}');
      emit(EventFilterLoaded(filteredEvents: events));
    } catch (e) {
      _logger.e('Failed to fetch events: $e');
      emit(EventFilterError(errorMessage: 'Failed to load events: $e'));
    }
  }
}
