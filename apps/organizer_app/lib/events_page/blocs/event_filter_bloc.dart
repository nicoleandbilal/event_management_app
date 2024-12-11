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

  if (event.brandIds.isEmpty) {
    // No brand IDs provided, cannot filter events.
    emit(EventFilterError(errorMessage: 'No brands available to filter.'));
        return;
      }

    try {
      List<Event> events;
      if (event.brandIds.length > 1) {
        _logger.d('Fetching events for multiple brands: ${event.brandIds}');
        events = await eventRepository.getEventsForAllUserBrands(event.brandIds, event.status);
      } else {
        _logger.d('Fetching events for brand: ${event.brandIds.first}');
        events = await eventRepository.getEventsByBrandAndStatus(
          brandId: event.brandIds.first,
          status: event.status,
        );
      }
      _logger.d('Fetched ${events.length} events successfully.');
      emit(EventFilterLoaded(filteredEvents: events));
    } catch (e) {
      _logger.e('Failed to fetch events: $e');
      emit(EventFilterError(errorMessage: 'Failed to load events: $e'));
    }
  }
}