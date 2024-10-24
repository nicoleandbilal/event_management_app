// event_list_item.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared/utils/date_and_time_formatter.dart';

class EventListItem extends StatelessWidget {
  final String eventName;
  final DateTime startDateTime;
  final String venue;
  final String eventCoverImageCroppedUrl;
  final VoidCallback onTap;

  const EventListItem({
    super.key,
    required this.eventName,
    required this.startDateTime,
    required this.venue,
    required this.eventCoverImageCroppedUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Use the combined date and time formatter
    String formattedDateTime = DateTimeFormatter.formatDateTime(startDateTime);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 0, // Slight elevation for separation
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: SizedBox(
          height: 120, // Set a fixed height for the entire item to fit content
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure children stretch to fill the height
            children: [
              // ClipRRect to ensure the image has rounded top-left and bottom-left corners
              eventCoverImageCroppedUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: eventCoverImageCroppedUrl,
                        width: MediaQuery.of(context).size.width * 0.35, // 35% of the width
                        height: double.infinity, // Ensure the image fills the full height of the item
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200], // Placeholder background if image fails
                          child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        ),
                      ),
                    )
                  : const SizedBox(width: 12),

              // Expanded widget to fill remaining space for the text group
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0), // Symmetric padding for the text group
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,  // Align text to the start of the column
                    mainAxisAlignment: MainAxisAlignment.center,    // Vertically center the text within the row
                    children: [
                      // Event Name
                      Flexible(
                        child: Text(
                          eventName,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                          overflow: TextOverflow.ellipsis,  // Ensure long text gets truncated
                          maxLines: 1,
                        ),
                      ),

                      // Small padding between text elements
                      const SizedBox(height: 4),

                      // Date and Time (with custom formatting)
                      Flexible(
                        child: Text(
                          formattedDateTime,  // Custom formatted date and time
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Colors.grey.shade600,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Small padding between text elements
                      const SizedBox(height: 4),

                      // Venue
                      Flexible(
                        child: Text(
                          venue,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Colors.grey.shade600,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,  // Ensure venue fits in one line
                        ),
                      ),

                      // Small padding between text elements
                      const SizedBox(height: 6),

                      // Price Range (this can be dynamic based on data in the future)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '£3 - £5',  // Price range (dummy text)
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
