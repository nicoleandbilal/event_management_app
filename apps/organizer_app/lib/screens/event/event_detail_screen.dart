// lib/screens/home/event_detail_screen.dart

import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

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
