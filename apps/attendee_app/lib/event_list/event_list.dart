// event_list.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'event_list_item.dart';

class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 50,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          // Show a loading indicator while waiting for the data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),  // Full-screen loading indicator
            );
          }

          // Handle errors
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // Get the event documents from the snapshot
          final events = snapshot.data!.docs;

          // If no events are found, show a message
          if (events.isEmpty) {
            return const Center(
              child: Text('No events found.'),
            );
          }

          // Once data is loaded, display the list of events
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final eventData = events[index].data() as Map<String, dynamic>;

              // Convert Firestore Timestamp to DateTime
              final Timestamp? startDateTimeTimestamp = eventData['startDateTime'] as Timestamp?;
              final DateTime? startDateTime = startDateTimeTimestamp?.toDate();

              // Build each event list item
              return EventListItem(
                eventName: eventData['eventName'] ?? 'No Name',
                startDateTime: startDateTime ?? DateTime.now(),
                venue: eventData['venue'] ?? 'No Venue',
                eventCoverImageCroppedUrl: eventData['eventCoverImageCroppedUrl'] ?? '',
                onTap: () {
                  context.push('/event_listing/${events[index].id}');
                },
              );
            },
          );
        },
      ),
    );
  }
}
