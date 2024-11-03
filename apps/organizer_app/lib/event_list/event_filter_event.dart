part of 'event_filter_bloc.dart';

abstract class EventFilterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FilterEventsByBrand extends EventFilterEvent {
  final String brandId;

  FilterEventsByBrand({required this.brandId});

  @override
  List<Object> get props => [brandId];
}

class FilterEventsByStatus extends EventFilterEvent {
  final String status;

  FilterEventsByStatus({required this.status});

  @override
  List<Object> get props => [status];
}
