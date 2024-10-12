import 'package:equatable/equatable.dart';
import 'package:shared/models/event_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

// Initial state when no search has been performed yet
class SearchInitial extends SearchState {}

// State while search results are being loaded
class SearchLoading extends SearchState {}

// State when search results have been successfully loaded
class SearchLoaded extends SearchState {
  final List<Event> results;

  const SearchLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

// State when an error occurs while fetching search results
class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}