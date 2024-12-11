import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/services/event_image_uploader_service.dart';
import 'package:organizer_app/event_creation/shared/screens/event_creation_modal.dart';
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
      return MultiBlocProvider(
        providers: [
          // Provide the EventFilterBloc at a higher level so EventListScreen can access it.
          BlocProvider(
            create: (_) => EventFilterBloc(
              eventRepository: getIt<EventRepository>(),
            ),
          ),
          // Provide the ChooseBrandDropdownBloc at a higher level so ChooseBrandDropdown can access it.
          BlocProvider(
            create: (_) => ChooseBrandDropdownBloc(
              brandRepository: getIt<BrandRepository>(),
            ),
          ),
        ],
        child: Stack(
          children: [
            EventListScreen(),
            child, // Nested routes will render here.
          ],
        ),
      );
    },
    routes: [
      GoRoute(
        path: '/create_event/:brandId',
        builder: (context, state) {
          final brandId = state.pathParameters['brandId']!;
          final userId = getIt<FirebaseAuth>().currentUser?.uid;

          if (userId == null) {
            return const LoginScreen();
          }

          // Show the event creation modal when creating a new event.
          return EventCreationModal(createdByUserId: userId);
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
          // Event editing screen, dependencies from GetIt as needed.
          return EditEventScreen(eventId: eventId);
        },
      ),
    ],
  ),
];