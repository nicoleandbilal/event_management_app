// lib/routes/home_routes.dart

import 'package:go_router/go_router.dart';
import 'package:organizer_app/screens/home/home_screen.dart';
import 'package:organizer_app/screens/profile/profile_screen.dart';
import 'package:organizer_app/screens/favorites/favorites_screen.dart';

List<GoRoute> homeRoutes = [
  GoRoute(
    path: '/home',
    builder: (context, state) {
      return const HomeScreen();
    },
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) {
      return const ProfileScreen();
    },
  ),
  GoRoute(
    path: '/favorites',
    builder: (context, state) {
      return const FavoritesScreen();
    },
  ),
];
