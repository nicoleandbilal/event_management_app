import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/event_creation_modal.dart';
import 'package:organizer_app/event_list/event_filter_bloc.dart';
import 'package:organizer_app/event_list/event_list_screen.dart';
import 'package:organizer_app/event_listing/event_listing_screen.dart';
import 'package:organizer_app/event_listing/edit_event_listing_screen.dart';
import 'package:shared/authentication/screens/login_screen.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:organizer_app/event_creation/event_cover_image/event_image_upload_service.dart';
import 'package:shared/repositories/image_repository.dart';

/// Dependency Injection for Event Routes
final eventRepository = EventRepository(firestore: FirebaseFirestore.instance);
final imageRepository = ImageRepository();
final imageUploadService = ImageUploadService(imageRepository, Logger());

List<RouteBase> eventRoutes = [
  ShellRoute(
    builder: (context, state, child) {
      return BlocProvider(
        create: (_) => EventFilterBloc(eventRepository: eventRepository),
        child: Stack(
          children: [
            const EventListScreen(),
            child, // Child routes are now properly scoped
          ],
        ),
      );
    },
    routes: [
      GoRoute(
        path: '/create_event/:brandId',
        builder: (context, state) {
          final brandId = state.pathParameters['brandId']!;
          final userId = FirebaseAuth.instance.currentUser?.uid;

          if (userId == null) {
            return const LoginScreen();
          }

          // Handle event creation modal
          return EventCreationModal(
            onShowModal: () {
              Logger().i("Event creation modal shown for brand ID: $brandId");
            },
            onHideModal: () {
              Logger().i("Event creation modal hidden for brand ID: $brandId");
            },
          );
        },
      ),
      GoRoute(
        path: '/event_listing/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return EventListingScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: '/edit_event/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return EditEventScreen(
            eventId: eventId,
            imageUploadService: imageUploadService,
          );
        },
      ),
    ],
  ),
];