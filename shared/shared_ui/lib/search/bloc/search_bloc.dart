import 'package:bloc/bloc.dart';
import 'package:shared/search/search_repository.dart'; 
import 'package:shared/search/bloc/search_state.dart'; 
import 'package:shared/search/bloc/search_event.dart'; 

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
        emit(const SearchError('No events found'));
      } else {
        emit(SearchLoaded(results));
      }
    } catch (error) {
      emit(const SearchError('Failed to fetch search results'));
    }
  }
}
