import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/events/event_repository.dart';
import 'package:shared/widgets/custom_padding_button.dart';
import 'package:shared/events/event_list/event_list.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padded content area for buttons and other widgets
        Padding(
          padding: const EdgeInsets.all(16.0), // Overall padding for main content
          child: Column(
            children: [
              // Create New Event button at the top
              CustomPaddingButton(
                onPressed: () {
                  // Navigate to CreateEventScreen
                  context.push(
                    '/create_event',
                    extra: context.read<EventRepository>(), // Pass repository
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
            ],
          ),
        ),

        // Divider that spans the full width of the screen
        const Divider(height: 1, color: Colors.grey),
        const SizedBox(height: 10),

        // Padded content area for row of buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Consistent side padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Drafts button
              Expanded(
                child: CustomPaddingButton(
                  onPressed: () {
                    // Action for Drafts
                  },
                  label: 'Drafts',
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                    minimumSize: const Size(0, 30),  // Smaller height
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Current button
              Expanded(
                child: CustomPaddingButton(
                  onPressed: () {
                    // Action for Current
                  },
                  label: 'Current',
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                    minimumSize: const Size(0, 30),  // Smaller height
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Past button
              Expanded(
                child: CustomPaddingButton(
                  onPressed: () {
                    // Action for Past
                  },
                  label: 'Past',
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                    minimumSize: const Size(0, 30),  // Smaller height
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ),
        //const SizedBox(height: 10),
        //const Divider(height: 1, color: Colors.grey),

        // Expanded widget for the event list
        const Expanded(
          child: EventList(),  // Display the event list here
        ),
        
      ],
    );
  }
}
