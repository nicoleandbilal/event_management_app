// lib/routes/event_routes.dart

import 'package:go_router/go_router.dart';
import 'package:organizer_app/create_event/screens/create_event_screen.dart';
import 'package:organizer_app/event_list/event_list_screen.dart';
import 'package:shared/events/event_individual_listing/event_listing_screen.dart';

List<GoRoute> eventRoutes = [
    GoRoute(
    path: '/events',
    builder: (context, state) {
      return const EventListScreen();  // Render the event creation screen
    },
  ),
  GoRoute(
    path: '/event_listing/:id',  // Dynamic route with event ID as a parameter
    builder: (context, state) {
      final String eventId = state.pathParameters['id']!;  // Get event ID from URL
      return EventListingScreen(eventId: eventId);  // Pass event ID to the screen
    },
  ),
  GoRoute(
    path: '/create_event',
    builder: (context, state) {
      return const CreateEventScreen();  // Render the event creation screen
    },
  ),
];
