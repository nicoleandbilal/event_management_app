// lib/config/router.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/authentication/auth_routes.dart';  // Authentication routes
import 'package:organizer_app/main_and_navigation/main_navigation_bloc.dart';
import 'package:organizer_app/main_and_navigation/navigation_routes.dart';          // Home routes
import 'package:organizer_app/event_list/edit_event_details_screen.dart';
import 'package:organizer_app/main_and_navigation/main_screen.dart';         // Main screen layout
import 'package:organizer_app/widgets/error_dialog.dart';
import 'package:organizer_app/create_event/screens/create_event_screen.dart'; // Create Event screen
import 'package:shared/authentication/auth/auth_bloc.dart';
import 'package:shared/event_list/event_listing/event_listing_screen.dart';

GoRouter createGoRouter(BuildContext context, AuthState authState) {
  return GoRouter(
    initialLocation: '/login',  // Default starting route
    redirect: (context, state) {
      final isAuthenticated = authState is Authenticated;
      final unauthenticatedPaths = ['/login', '/register', '/forgot_password'];
      final isOnUnauthenticatedPage = unauthenticatedPaths.contains(state.uri.path);

      // Redirect unauthenticated users to /login
      if (!isAuthenticated && !isOnUnauthenticatedPage) {
        return '/login';
      }

      // Redirect authenticated users from login/register/forgot_password to /home
      if (isAuthenticated && isOnUnauthenticatedPage) {
        return '/home';
      }

      return null;  // No redirect needed
    },
    routes: [
      ...authRoutes,  // Authentication-related routes (/login, /register, etc.)
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) => MainNavigationBloc(), // Bloc only for MainScreen and tabs
            child: MainScreen(child: child),
          );
        },
        routes: [
          ...navigationRoutes,  // All home-related routes (/home, /search, etc.)
        ],
      ),
      // Full-screen routes (not wrapped with MainScreen)
      GoRoute(
        path: '/create_event',
        builder: (context, state) => const CreateEventScreen(),  // Full-screen create event
      ),
      GoRoute(
        path: '/event_listing/:id',  // Event details screen (full-screen)
        builder: (context, state) {
          final String eventId = state.pathParameters['id']!;
          return EventListingScreen(eventId: eventId);  // Pass event ID
        },
      ),
      GoRoute(
        path: '/edit_event/:id',  // Edit event screen (full-screen)
        builder: (context, state) {
          final String eventId = state.pathParameters['id']!;
          return EditEventScreen(eventId: eventId);  // Pass event ID
        },
      ),
      // Error handling route
      GoRoute(
        path: '/error',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final message = extra != null && extra['message'] is String
              ? extra['message'] as String
              : 'An error occurred.';
          return CustomTransitionPage(
            key: state.pageKey,
            child: ErrorDialog(message: message),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
}
