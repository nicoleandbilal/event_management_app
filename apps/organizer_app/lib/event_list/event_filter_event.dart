part of 'event_filter_bloc.dart';

abstract class EventFilterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FilterEvents extends EventFilterEvent {
  final List<String> brandIds; // List of brand IDs (for "All" or specific brand)
  final String? status;

  FilterEvents({
    required this.brandIds,
    this.status,
  });

  @override
  List<Object?> get props => [brandIds, status];
}
