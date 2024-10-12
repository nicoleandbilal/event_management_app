import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/routes/auth_routes.dart';
import 'package:organizer_app/routes/home_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/screens/main_screen.dart';
import 'package:shared/blocs/auth/auth_bloc.dart';

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

      return null;  // No redirect needed
    },
    routes: [
      ...authRoutes,  // This includes the /login, /register, /forgot_password routes
      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(child: child);  // Wrap home-related routes in MainScreen
        },
        routes: homeRoutes,  // All home-related routes are defined in homeRoutes
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('404 - Page Not Found'),
      ),
    ),
  );
}
