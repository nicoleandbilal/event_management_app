// organizer_event_list.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'organizer_event_list_item.dart';
import 'package:shared/models/event_model.dart';

class OrganizerEventList extends StatelessWidget {
  final List<Event> events;

  const OrganizerEventList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(child: Text('No events found.'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return OrganizerEventListItem(
          eventName: event.eventName,
          startDateTime: event.startDateTime,
          venue: event.venue,
          eventCoverImageCroppedUrl: event.eventCoverImageCroppedUrl ?? '',
          onTap: () {
            context.push('/event_listing/${event.eventId}');
          },
        );
      },
    );
  }
}
