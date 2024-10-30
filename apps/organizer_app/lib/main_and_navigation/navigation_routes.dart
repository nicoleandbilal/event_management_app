// lib/routes/navigation_routes.dart

import 'package:go_router/go_router.dart';
import 'package:organizer_app/home/home_screen.dart';
import 'package:organizer_app/profile/organizer_profile_screen.dart';
import 'package:organizer_app/event_list/event_list_screen.dart';
import 'package:shared/page_transitions.dart'; 

List<GoRoute> navigationRoutes = [
  GoRoute(
    path: '/home',
    pageBuilder: (context, state) => buildPageWithFadeTransition(const HomeScreen(), state),
  ),
  GoRoute(
    path: '/events',
    pageBuilder: (context, state) => buildPageWithFadeTransition(const EventListScreen(), state),
  ),
  GoRoute(
    path: '/scanner',
    pageBuilder: (context, state) => buildPageWithFadeTransition(const OrganizerProfileScreen(), state),
  ),
  GoRoute(
    path: '/orders',
    pageBuilder: (context, state) => buildPageWithFadeTransition(const OrganizerProfileScreen(), state),
  ),
  GoRoute(
    path: '/profile',
    pageBuilder: (context, state) => buildPageWithFadeTransition(const OrganizerProfileScreen(), state),
  ),
];
