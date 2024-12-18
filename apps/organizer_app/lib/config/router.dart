// lib/config/router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/config/routes/event_routes.dart';
import 'package:organizer_app/main_and_navigation/main_navigation_bloc.dart';
import 'package:organizer_app/main_and_navigation/navigation_routes.dart';
import 'package:organizer_app/main_and_navigation/main_screen.dart';
import 'package:organizer_app/profile/profile_routes.dart';
import 'package:organizer_app/core/widgets/error_dialog.dart';
import 'package:shared/authentication/auth/auth_bloc.dart';
import 'package:shared/authentication/auth_routes.dart';

GoRouter createGoRouter(BuildContext context, AuthState authState) {
  return GoRouter(
    initialLocation: '/login', // Default starting route
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
      ...authRoutes, // Authentication-related routes
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) => MainNavigationBloc(), // Bloc for MainScreen tabs
            child: MainScreen(child: child), // Main screen layout
          );
        },
        routes: [
          ...navigationRoutes, // Home-related routes
          ...profileRoutes,    // Profile-related routes
        ],
      ),
      ...eventRoutes, // Event-related routes, including modal and list
      // Error route
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
