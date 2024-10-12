import 'package:equatable/equatable.dart';
import 'package:shared/blocs/search/search_bloc.dart';  // Link to the main file

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

// Event when search query changes
class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}