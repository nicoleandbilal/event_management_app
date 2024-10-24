// lib/routes/home_routes.dart
import 'package:attendee_app/screens/favorites/favorites_screen.dart';
import 'package:attendee_app/screens/profile_screen.dart';
import 'package:attendee_app/screens/search/search_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:attendee_app/screens/home/home_screen.dart';  // Assuming you have this screen

List<GoRoute> homeRoutes = [
  GoRoute(
    path: '/home',
    pageBuilder: (context, state) => const NoTransitionPage(
      child: HomeScreen(), // home screen wrapped in main screen
    ),
  ),
  GoRoute(
    path: '/search',
    pageBuilder: (context, state) => const NoTransitionPage(
      child: SearchScreen(), // Wrap in MainScreen
    ),
  ),
  GoRoute(
    path: '/favorites',
    pageBuilder: (context, state) => const NoTransitionPage(
      child: FavoritesScreen(), // Wrap in MainScreen
    ),
  ),
  GoRoute(
    path: '/profile',
    pageBuilder: (context, state) => const NoTransitionPage(
      child: ProfileScreen(), // Wrap in MainScreen
    ),
  ),
];