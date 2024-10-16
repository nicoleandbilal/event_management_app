// lib/routes/event_routes.dart

import 'package:go_router/go_router.dart';
import 'package:organizer_app/screens/events/event_details_screen.dart';
import 'package:organizer_app/screens/events/create_event_screen.dart';

List<GoRoute> eventRoutes = [
  GoRoute(
    path: '/create_event',
    builder: (context, state) {
      return const CreateEventScreen();
    },
  ),
  GoRoute(
    path: '/event_details/:id', // Dynamic route with event ID as a parameter
    builder: (context, state) {
      // Retrieve the event ID from state.params
      final String eventId = state.pathParameters['id']!;
      return EventDetailsScreen(eventId: eventId); // Pass the event ID to the screen
    },
  ),
];
