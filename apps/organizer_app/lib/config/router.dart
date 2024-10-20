// lib/config/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/authentication/auth_routes.dart';  // Authentication routes
import 'package:organizer_app/routes/home_routes.dart';          // Home routes
import 'package:organizer_app/screens/events/edit_event_details_screen.dart';
import 'package:organizer_app/screens/events/event_details_screen.dart';
import 'package:organizer_app/screens/main_screen.dart';         // Main screen layout
import 'package:organizer_app/widgets/error_dialog.dart';
import 'package:organizer_app/create_event/screens/create_event_screen.dart'; // Create Event screen

import 'package:shared/authentication/auth/auth_bloc.dart';

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
          return MainScreen(child: child);  // Wraps child content with MainScreen
        },
        routes: [
          ...homeRoutes,  // All home-related routes (/home, /search, etc.)
        ],
      ),
      // Full-screen routes (not wrapped with MainScreen)
      GoRoute(
        path: '/create_event',
        builder: (context, state) => const CreateEventScreen(),  // Full-screen create event
      ),
      GoRoute(
        path: '/event_details/:id',  // Event details screen (full-screen)
        builder: (context, state) {
          final String eventId = state.pathParameters['id']!;
          return EventDetailsScreen(eventId: eventId);  // Pass event ID
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
