part of 'event_filter_bloc.dart';

abstract class EventFilterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventFilterInitial extends EventFilterState {}

class EventFilterLoading extends EventFilterState {}

class EventFilterLoaded extends EventFilterState {
  final List<Event> filteredEvents;

  EventFilterLoaded({required this.filteredEvents});

  @override
  List<Object?> get props => [filteredEvents];
}

class EventFilterError extends EventFilterState {
  final String errorMessage;

  EventFilterError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
