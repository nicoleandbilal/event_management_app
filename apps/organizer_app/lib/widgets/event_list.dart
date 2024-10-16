// lib/widgets/event_list.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organizer_app/widgets/event_list_item.dart';
import 'package:organizer_app/screens/events/event_details_screen.dart';

class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final events = snapshot.data!.docs;

        if (events.isEmpty) {
          return const Center(
            child: Text('No events found.'),
          );
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final eventData = events[index].data() as Map<String, dynamic>;
            return EventListItem(
              name: eventData['name'] ?? 'No Name',
              description: eventData['description'] ?? 'No Description',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsScreen(eventId: events[index].id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
