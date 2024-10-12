import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/repositories/search_repository.dart'; 
import 'package:shared/blocs/search/search_state.dart'; 
import 'package:shared/blocs/search/search_event.dart'; 
import 'package:shared/models/event_model.dart'; 


class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({required this.searchRepository}) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  // Method that handles the search logic when SearchQueryChanged event is fired
  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim(); // Make sure to trim the input
    if (query.isEmpty) {
      emit(SearchInitial()); // Reset the state if the query is empty
      return;
    }

    emit(SearchLoading()); // Show loading state
    try {
      final results = await searchRepository.searchEvents(query); // Fetch results
      if (results.isEmpty) {
        emit(SearchError('No events found'));
      } else {
        emit(SearchLoaded(results));
      }
    } catch (error) {
      emit(SearchError('Failed to fetch search results'));
    }
  }
}
