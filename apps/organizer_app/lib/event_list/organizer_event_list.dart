import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'organizer_event_list_item.dart';
import 'package:shared/models/event_model.dart';

class OrganizerEventList extends StatelessWidget {
  final List<Event> events;
  final EdgeInsetsGeometry? padding;

  const OrganizerEventList({
    super.key,
    required this.events,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(child: Text('No events found.'));
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
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
      ),
    );
  }
}
