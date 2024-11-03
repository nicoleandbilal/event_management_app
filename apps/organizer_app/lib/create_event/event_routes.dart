// lib/routes/event_routes.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/create_event/screens/create_event_screen.dart';
import 'package:organizer_app/event_list/event_filter_bloc.dart';
import 'package:organizer_app/event_list/event_list_screen.dart';
import 'package:organizer_app/event_listing/edit_event_listing_screen.dart';
import 'package:shared/events/event_individual_listing/event_listing_screen.dart';
import 'package:shared/repositories/event_repository.dart';

List<GoRoute> eventRoutes = [
  GoRoute(
      path: '/events',
      builder: (context, state) => BlocProvider(
        create: (_) => EventFilterBloc(eventRepository: EventRepository(
          firestore: FirebaseFirestore.instance,
        )),
        child: const EventListScreen(),
      ),
    ),
  GoRoute(
    path: '/event_listing/:id',  // Dynamic route with event ID as a parameter
    builder: (context, state) {
      final String eventId = state.pathParameters['id']!;  // Get event ID from URL
      return EventListingScreen(eventId: eventId);  // Pass event ID to the screen
    },
  ),
  GoRoute(
    path: '/create_event/:brandId',
    builder: (context, state) {
      final String brandId = state.pathParameters['brandId']!;  // Extract brandId from path
      return CreateEventScreen(brandId: brandId);  // Render the event creation screen
    },
  ),

  GoRoute(
        path: '/edit_event/:id',  // Edit event screen (full-screen)
        builder: (context, state) {
          final String eventId = state.pathParameters['id']!;
          return EditEventScreen(eventId: eventId);  // Pass event ID
      },
    ),
];