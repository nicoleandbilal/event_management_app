import 'package:go_router/go_router.dart';
import 'package:organizer_app/screens/home/home_screen.dart';
import 'package:organizer_app/screens/profile_screen.dart';
import 'package:organizer_app/screens/search/search_screen.dart';
import 'package:organizer_app/screens/favorites/favorites_screen.dart';
import 'package:organizer_app/screens/events/create_event_screen.dart';

List<GoRoute> homeRoutes = [
  GoRoute(
    path: '/home',
    pageBuilder: (context, state) => const NoTransitionPage(
      child: HomeScreen(),
    ),
  ),
  GoRoute(
    path: '/search',
    pageBuilder: (context, state) => const NoTransitionPage(
      child: SearchScreen(),
    ),
  ),
  GoRoute(
    path: '/favorites',
    pageBuilder: (context, state) => const NoTransitionPage(
      child: FavoritesScreen(),
    ),
  ),
  GoRoute(
    path: '/profile',
    pageBuilder: (context, state) => const NoTransitionPage(
      child: ProfileScreen(),
    ),
  ),
  // Full-screen route for Create Event Form, now BlocProvider is handled inside CreateEventScreen
  GoRoute(
    path: '/create_event',
    builder: (context, state) {
      return const CreateEventScreen();  // BlocProvider is inside CreateEventScreen
    },
  ),
];
