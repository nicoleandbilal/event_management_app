import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/basic_details/blocs/basic_details_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/services/basic_details_service.dart';
import 'package:organizer_app/event_creation/finishing_details/blocs/finishing_details_bloc.dart';
import 'package:organizer_app/event_creation/finishing_details/services/finishing_details_service.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_bloc.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_event.dart';
import 'package:organizer_app/event_creation/shared/screens/event_creation_modal.dart';
import 'package:organizer_app/event_creation/shared/services/event_creation_service.dart';
import 'package:organizer_app/event_creation/ticket_details/blocs/ticket_details_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/services/ticket_details_service.dart';
import 'package:organizer_app/events_page/blocs/event_filter_bloc.dart';
import 'package:organizer_app/events_page/choose_brand/blocs/choose_brand_dropdown_bloc.dart';
import 'package:organizer_app/events_page/screens/event_list_screen.dart';
import 'package:organizer_app/event_listing/edit_event_listing_screen.dart';
import 'package:organizer_app/event_listing/event_listing_screen.dart';
import 'package:shared/authentication/screens/login_screen.dart';
import 'package:shared/repositories/brand_repository.dart';
import 'package:shared/repositories/event_repository.dart';

final getIt = GetIt.instance;

List<RouteBase> eventRoutes = [
  ShellRoute(
    builder: (context, state, child) {
      // The ShellRoute ensures EventListScreen remains visible in the background.
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => EventFilterBloc(
              eventRepository: getIt<EventRepository>(),
            ),
          ),
          BlocProvider(
            create: (_) => ChooseBrandDropdownBloc(
              brandRepository: getIt<BrandRepository>(),
            ),
          ),
        ],
        child: Stack(
          children: [
            const EventListScreen(), // Background Event List Screen
            child, // Overlay children like modal or details
          ],
        ),
      );
    },
    routes: [
      // Route for event creation modal
      GoRoute(
        path: '/create_event/:brandId',
        builder: (context, state) {
          final brandId = state.pathParameters['brandId']!;
          final userId = getIt<FirebaseAuth>().currentUser?.uid;

          if (userId == null) {
            // Redirect to login screen if not authenticated
            return const LoginScreen();
          }

          // Provide all necessary blocs for the modal and its child pages
          return BlocProvider(
                create: (context) => EventCreationBloc(
                  getIt<EventCreationService>(),
                )..add(InitializeEventCreation(userId)),
            child: EventCreationModal(createdByUserId: userId, brandId: brandId,),
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
      // Route for editing an event
      GoRoute(
        path: '/edit_event/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return EditEventScreen(eventId: eventId);
        },
      ),
    ],
  ),
];