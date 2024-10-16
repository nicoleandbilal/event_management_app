// lib/widgets/event_list_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListItem extends StatelessWidget {
  final String name;
  final DateTime startDateTime;
  final String venue;
  final String imageUrl; // Example for a more complex layout
  final VoidCallback onTap;

  const EventListItem({
    super.key,
    required this.name,
    required this.startDateTime,
    required this.venue,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(startDateTime);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading Image/Icon
              imageUrl.isNotEmpty 
                  ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover):
              
              const SizedBox(width: 12),

              // Main content in a Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleLarge), // Title
                    const SizedBox(height: 4),
                    Text(formattedDate), // Date
                    const SizedBox(height: 4),
                    Text(venue), // Venue
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

