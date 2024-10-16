// lib/config/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/routes/auth_routes.dart';
import 'package:organizer_app/routes/event_routes.dart'; // Import the event routes
import 'package:organizer_app/routes/home_routes.dart';
import 'package:organizer_app/screens/events/create_event_screen.dart';
import 'package:organizer_app/screens/main_screen.dart';
import 'package:shared/blocs/all_auth/auth/auth_bloc.dart';
import 'package:organizer_app/widgets/error_dialog.dart';

GoRouter createGoRouter(BuildContext context, AuthState authState) {
  return GoRouter(
    initialLocation: '/login',
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

      return null; // No redirect needed
    },
    routes: [
      ...authRoutes, // Includes /login, /register, /forgot_password routes
      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(child: child); // Wrap home-related routes in MainScreen
        },
        routes: [
          ...homeRoutes, // All home-related routes
          ...eventRoutes, // Include the event routes
        ],
      ),
      // Full-screen routes (outside the ShellRoute)
      GoRoute(
        path: '/create_event',
        builder: (context, state) => const CreateEventScreen(),
      ),
      // Error dialog route
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
