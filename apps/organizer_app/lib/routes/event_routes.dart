// lib/routes/event_routes.dart

import 'package:go_router/go_router.dart';
import 'package:organizer_app/screens/events/event_details_screen.dart';
import 'package:organizer_app/create_event/screens/create_event_screen.dart';

List<GoRoute> eventRoutes = [
  GoRoute(
    path: '/event_details/:id',  // Dynamic route with event ID as a parameter
    builder: (context, state) {
      final String eventId = state.pathParameters['id']!;  // Get event ID from URL
      return EventDetailsScreen(eventId: eventId);  // Pass event ID to the screen
    },
  ),
  GoRoute(
    path: '/create_event',
    builder: (context, state) {
      return const CreateEventScreen();  // Render the event creation screen
    },
  ),
];
