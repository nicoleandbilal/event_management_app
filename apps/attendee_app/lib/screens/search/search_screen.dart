import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/blocs/search/search_bloc.dart';
import 'package:shared/blocs/search/search_event.dart';
import 'package:shared/blocs/search/search_state.dart';
import 'package:shared/repositories/search_repository.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: BlocProvider(
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
                      return ListView.builder(
                        itemCount: state.results.length,
                        itemBuilder: (context, index) {
                          final event = state.results[index];
                          return ListTile(
                            title: Text(event.name),
                            subtitle: Text(event.details),
                          );
                        },
                      );
                    } else if (state is SearchError) {
                      return Center(child: Text(state.message));
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}