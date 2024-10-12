// lib/screens/home/event_detail_screen.dart

import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch event details using eventId
    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: Center(
        child: Text('Details for Event ID: $eventId'),
      ),
    );
  }
}
