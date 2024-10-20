import 'package:flutter/material.dart';
import 'package:shared/utils/date_formatter.dart';

class EventListItem extends StatelessWidget {
  final String eventName;
  final DateTime startDateTime;
  final String venue;
  final String imageUrl;
  final VoidCallback onTap;

  const EventListItem({
    super.key,
    required this.eventName,
    required this.startDateTime,
    required this.venue,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Use the custom date formatter
    String formattedDate = DateFormatter.formatDate(startDateTime);

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
              imageUrl.isNotEmpty 
                  ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                  : const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(eventName, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(formattedDate), // Use the formatted date
                    const SizedBox(height: 4),
                    Text(venue), 
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
