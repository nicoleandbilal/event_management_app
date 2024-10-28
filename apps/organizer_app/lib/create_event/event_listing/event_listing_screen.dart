// lib/screens/event_listing_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/events/event_individual_listing/bloc/event_listing_bloc.dart';
import 'package:shared/events/event_repository.dart';
import 'package:shared/models/event_model.dart';
import 'package:shared/utils/date_and_time_formatter.dart';

class EventListingScreen extends StatelessWidget {
  final String eventId;

  const EventListingScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventListingBloc(
        RepositoryProvider.of<EventRepository>(context),
      )..add(LoadEventListing(eventId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Event Listing')),
        body: BlocBuilder<EventListingBloc, EventListingState>(
          builder: (context, state) {
            if (state is EventListingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventListingError) {
              return Center(child: Text('Error fetching event details: ${state.error}'));
            } else if (state is EventListingLoaded) {
              // Debug print to verify event data
              print('Start DateTime: ${state.event.startDateTime}');
              print('End DateTime: ${state.event.endDateTime}');
              
              // Build event details with custom formatting
              return _buildEventDetails(context, state.event);
            }
            return const Center(child: Text('No Data Available'));
          },
        ),
      ),
    );
  }

  Widget _buildEventDetails(BuildContext context, Event event) {
    // Ensure valid DateTime objects are passed
    final String formattedStartDateTime = DateTimeFormatter.formatDateTime(event.startDateTime);
    final String formattedEndDateTime = DateTimeFormatter.formatDateTime(event.endDateTime);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image
          if (event.eventCoverImageCroppedUrl != null && event.eventCoverImageCroppedUrl!.isNotEmpty)
            Image.network(
              event.eventCoverImageCroppedUrl!,
              width: MediaQuery.of(context).size.width,  // Full width of the screen
              fit: BoxFit.cover,
            )
          else
            const Placeholder(
              fallbackHeight: 200,
              fallbackWidth: double.infinity,
            ),
          
          // Padding for text content below the image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Name
                Text(
                  event.eventName ?? 'No Event Name',   // Fallback for eventName
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
                      '$formattedStartDateTime - $formattedEndDateTime',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Venue
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      event.venue ?? 'Venue not specified',   // Fallback for venue
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Event description
                Text(
                  event.description ?? 'No Description Available',   // Fallback for description
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
