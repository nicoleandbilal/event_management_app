// lib/screens/event_listing_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/events/event_individual_listing/bloc/event_listing_bloc.dart';
import 'package:shared/models/event_model.dart';
import 'package:shared/events/event_repository.dart';
import 'package:shared/utils/date_and_time_formatter.dart'; // Import for date and time formatting

class EventListingScreen extends StatelessWidget {
  final String eventId;

  const EventListingScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventListingBloc(
        RepositoryProvider.of<EventRepository>(context),
      )..add(LoadEventListing(eventId)), // Trigger the event load
      child: Scaffold(
        appBar: AppBar(title: const Text('Event Listing')),
        body: BlocBuilder<EventListingBloc, EventListingState>(
          builder: (context, state) {
            if (state is EventListingLoading) {
              // Show loading indicator while data is being fetched
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventListingError) {
              // Show error message if data fetching fails
              return Center(child: Text('Error fetching event details: ${state.error}'));
            } else if (state is EventListingLoaded) {
              // Log for debugging purposes
              print('Start DateTime: ${state.event.startDateTime}');
              print('End DateTime: ${state.event.endDateTime}');
              
              // Build and display event details with custom date-time formatting
              return _buildEventDetails(context, state.event);
            }
            return const Center(child: Text('No Data Available'));
          },
        ),
      ),
    );
  }

  // Builds the main UI for event details
  Widget _buildEventDetails(BuildContext context, Event event) {
    // Format start and end date-time with new conditional display logic
    final String formattedEventDateTime = DateTimeFormatter.formatEventDateTime(event.startDateTime, event.endDateTime);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image section
          if (event.eventCoverImageCroppedUrl != null && event.eventCoverImageCroppedUrl!.isNotEmpty)
            Image.network(
              event.eventCoverImageCroppedUrl!,
              width: MediaQuery.of(context).size.width,  // Full screen width
              fit: BoxFit.cover,
            )
          else
            const Placeholder(
              fallbackHeight: 200,
              fallbackWidth: double.infinity,
            ),
          
          // Padding for the text content below the image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Name
                Text(
                  event.eventName ?? 'No Event Name',   // Fallback if event name is null
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Event Date and Time
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      formattedEventDateTime, // Display formatted date and time
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Venue section
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      event.venue ?? 'Venue not specified',   // Fallback if venue is null
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Event description
                Text(
                  event.description ?? 'No Description Available',   // Fallback if description is null
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
