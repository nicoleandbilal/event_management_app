import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/widgets/event_list_item.dart';

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

            // Convert Firestore Timestamp to DateTime
            final Timestamp? startDateTimeTimestamp = eventData['startDateTime'] as Timestamp?;
            final DateTime? startDateTime = startDateTimeTimestamp?.toDate();

            return EventListItem(
              eventName: eventData['eventName'] ?? 'No Name',
              startDateTime: startDateTime ?? DateTime.now(), // Fallback to current date if null
              venue: eventData['venue'] ?? 'No Venue',
              imageUrl: eventData['imageUrl'] ?? '',
              onTap: () {
                // Use GoRouter to navigate to the event details screen
                context.push(
                  '/event_details/${events[index].id}', // Assuming you have a route like '/event-details/:id'
                );
              },
            );
          },
        );
      },
    );
  }
}
