// lib/routes/navigation_routes.dart

import 'package:attendee_app/meet/meet_screen.dart';
import 'package:attendee_app/my_tickets/my_tickets_screen.dart';
import 'package:attendee_app/screens/home/home_screen.dart';
import 'package:attendee_app/screens/profile_screen.dart';
import 'package:attendee_app/screens/search/search_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/page_transitions.dart'; 


List<GoRoute> navigationRoutes = [
  GoRoute(
    path: '/home',
    pageBuilder: (context, state) => buildPageWithFadeTransition(const HomeScreen(), state),
  ),
  GoRoute(
    path: '/search',
    pageBuilder: (context, state) => buildPageWithFadeTransition(const SearchScreen(), state),
  ),
  GoRoute(
    path: '/meet',
    pageBuilder: (context, state) => buildPageWithFadeTransition(const MeetScreen(), state),
  ),
  GoRoute(
    path: '/myTickets',
    pageBuilder: (context, state) => buildPageWithFadeTransition(const MyTicketsScreen(), state),
  ),
  GoRoute(
    path: '/profile',
    pageBuilder: (context, state) => buildPageWithFadeTransition(const ProfileScreen(), state),
  ),
];
