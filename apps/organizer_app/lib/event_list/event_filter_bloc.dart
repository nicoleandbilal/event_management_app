import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/models/event_model.dart';

part 'event_filter_event.dart';
part 'event_filter_state.dart';

class EventFilterBloc extends Bloc<EventFilterEvent, EventFilterState> {
  final EventRepository eventRepository;

  EventFilterBloc({required this.eventRepository}) : super(EventFilterInitial()) {
    on<FilterEventsByBrand>(_onFilterEventsByBrand);
    on<FilterEventsByStatus>(_onFilterEventsByStatus);
  }

  // Filter events by selected brand ID
  Future<void> _onFilterEventsByBrand(
    FilterEventsByBrand event, 
    Emitter<EventFilterState> emit
  ) async {
    emit(EventFilterLoading());
    try {
      final events = await eventRepository.getEventsByBrand(event.brandId);
      emit(EventFilterLoaded(filteredEvents: events));
    } catch (e) {
      emit(EventFilterError(errorMessage: 'Failed to load events.'));
    }
  }

  // Filter events by status (e.g., Draft, Current, Past)
  Future<void> _onFilterEventsByStatus(
    FilterEventsByStatus event, 
    Emitter<EventFilterState> emit
  ) async {
    emit(EventFilterLoading());
    try {
      final events = await eventRepository.getEventsByStatus(event.status);
      emit(EventFilterLoaded(filteredEvents: events));
    } catch (e) {
      emit(EventFilterError(errorMessage: 'Failed to load events by status.'));
    }
  }
}
