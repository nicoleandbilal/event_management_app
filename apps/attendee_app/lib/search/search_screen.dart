import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/search/search_repository.dart';
import 'package:shared/search/bloc/search_bloc.dart';
import 'package:shared/search/bloc/search_event.dart';
import 'package:shared/search/bloc/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(
        searchRepository: SearchRepository(firestore: FirebaseFirestore.instance),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search input field
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search events...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                // Dispatch SearchQueryChanged event
                context.read<SearchBloc>().add(SearchQueryChanged(query));
              },
            ),
            const SizedBox(height: 16),
            // BlocBuilder to listen to the SearchBloc states
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return const Center(child: Text('Start searching for events'));
                  } else if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchLoaded) {
                    if (state.results.isEmpty) {
                      return const Center(child: Text('No events found.'));
                    }
                    return ListView.builder(
                      itemCount: state.results.length,
                      itemBuilder: (context, index) {
                        final event = state.results[index];
                        return ListTile(
                          leading: const Icon(Icons.event),
                          title: Text(event.eventName),
                          onTap: () {
                            // Handle event tap if necessary
                          },
                        );
                      },
                    );
                  } else if (state is SearchError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}