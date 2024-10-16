import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/widgets/create_event_button.dart';
import 'package:organizer_app/widgets/event_list.dart';
import 'package:organizer_app/blocs/create_event/create_event_form_bloc.dart';
import 'package:organizer_app/repositories/create_event_repository.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Button at the top
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CreateEventButton(
            onPressed: () {
              // Use GoRouter to navigate to the CreateEventScreen
              context.push(
                '/create_event', // This route should be configured in GoRouter
                extra: context.read<CreateEventRepository>(), // Pass repository using 'extra'
              );
            },
            label: 'Create New Event',
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey,
              minimumSize: const Size(double.infinity, 40),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        // Divider for visual separation
        const Divider(height: 1, color: Colors.grey),
        // Expanded widget to make the list take up remaining space
        const Expanded(
          child: EventList(),
        ),
      ],
    );
  }
}
