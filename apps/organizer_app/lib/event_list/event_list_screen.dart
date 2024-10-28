import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/events/event_repository.dart';
import 'package:shared/widgets/custom_padding_button.dart';
import 'package:shared/widgets/custom_padding_button.dart';
import 'package:shared/events/event_list/event_list.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Button at the top
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomPaddingButton(
            onPressed: () {
              // Use GoRouter to navigate to the full-screen CreateEventScreen
              context.push(
                '/create_event', // Navigate to the full-screen CreateEventScreen
                extra: context.read<EventRepository>(), // Pass repository using 'extra'
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
        const Divider(height: 1, color: Colors.grey),

        // Buttons for Drafts, Current and Past



        const Expanded(
          child: EventList(),  // Display the event list here
        ),
      ],
    );
  }
}
