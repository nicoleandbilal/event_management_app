import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/event_cover_image/event_image_upload_service.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_bloc.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_event.dart';
import 'package:organizer_app/event_creation/event_creation_modal.dart';
import 'package:organizer_app/event_list/event_filter_bloc.dart';
import 'package:organizer_app/event_list/event_list_screen.dart';
import 'package:organizer_app/event_listing/edit_event_listing_screen.dart';
import 'package:organizer_app/event_listing/event_listing_screen.dart';
import 'package:shared/authentication/screens/login_screen.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/image_repository.dart';
import 'package:shared/repositories/ticket_repository.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_bloc.dart';

/// Helper function to fetch the current user's ID.
String? getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}

/// Create instances of required services, repositories, and blocs.
final EventRepository eventRepository = EventRepository(
  firestore: FirebaseFirestore.instance,
);

final TicketRepository ticketRepository = TicketRepository(
  firestore: FirebaseFirestore.instance,
);

final ImageRepository imageRepository = ImageRepository();

final Logger logger = Logger();

/// List of application routes
List<RouteBase> eventRoutes = [
  // Shell Route for Event List and Create Event Modal
  ShellRoute(
    builder: (context, state, child) {
      return Stack(
        children: [
          // Base: Event List Screen
          BlocProvider(
            create: (_) => EventFilterBloc(eventRepository: eventRepository),
            child: const EventListScreen(),
          ),
          // Overlay: Child Routes (e.g., Create Event Modal)
          child,
        ],
      );
    },
    routes: [
      // Event Creation Modal
      GoRoute(
        path: '/create_event/:brandId',
        builder: (context, state) {
          final String brandId = state.pathParameters['brandId']!;
          final String? userId = getCurrentUserId();

          if (userId == null) {
            return const LoginScreen(); // Redirect to login if not authenticated
          }

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => BasicDetailsBloc(
                  eventRepository: eventRepository,
                  imageUploadService: ImageUploadService(imageRepository, logger),
                  eventId: '', // Event ID initialized later
                ),
              ),
              BlocProvider(
                create: (_) => TicketDetailsBloc(ticketRepository: ticketRepository),
              ),
              BlocProvider(
                create: (_) => EventCreationBloc(
                  eventRepository: eventRepository,
                  ticketRepository: ticketRepository,
                  basicDetailsBloc: context.read<BasicDetailsBloc>(),
                  ticketDetailsBloc: context.read<TicketDetailsBloc>(),
                )..add(InitializeEventCreation(userId)),
              ),
            ],
            child: EventCreationScreen(userId: userId, brandId: brandId),
          );
        },
      ),
    ],
  ),

  // Individual Event Listing Screen
  GoRoute(
    path: '/event_listing/:id', // Dynamic route with event ID as a parameter
    builder: (context, state) {
      final String eventId = state.pathParameters['id']!;
      return EventListingScreen(eventId: eventId); // Pass eventId explicitly
    },
  ),

  // Edit Event Screen
  GoRoute(
    path: '/edit_event/:id',
    builder: (context, state) {
      final String eventId = state.pathParameters['id']!;
      return EditEventScreen(
        eventId: eventId,
        imageUploadService: ImageUploadService(imageRepository, logger),
      );
    },
  ),
];
