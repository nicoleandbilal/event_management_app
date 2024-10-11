import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/routes/auth_routes.dart';
import 'package:organizer_app/routes/home_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/blocs/auth/auth_bloc.dart';

GoRouter createGoRouter(BuildContext context, AuthState authState) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState is Authenticated;
      final unauthenticatedPaths = ['/login', '/register', '/forgot_password'];
      final isOnUnauthenticatedPage = unauthenticatedPaths.contains(state.uri.path);

      if (!isAuthenticated && !isOnUnauthenticatedPage) {
        return '/login';
      }

      if (isAuthenticated && isOnUnauthenticatedPage) {
        return '/home';
      }

      return null;
    },
    routes: [
      ...authRoutes,  // This includes the /register route
      ...homeRoutes,
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('404 - Page Not Found'),
      ),
    ),
  );
}
