import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:organizer_app/events_page/blocs/event_filter_bloc.dart';
import 'package:organizer_app/events_page/choose_brand/blocs/choose_brand_dropdown_bloc.dart';
import 'package:organizer_app/home/home_screen.dart';
import 'package:organizer_app/profile/organizer_profile_screen.dart';
import 'package:organizer_app/events_page/screens/event_list_screen.dart';
import 'package:organizer_app/ticket_scanning/presentation/screens/scan_screen.dart';
import 'package:shared/repositories/brand_repository.dart';

import 'package:shared/page_transitions.dart';
import 'package:shared/repositories/event_repository.dart';

final GetIt getIt = GetIt.instance;

List<GoRoute> navigationRoutes = [
  GoRoute(
    path: '/home',
    pageBuilder: (context, state) {
      return buildPageWithFadeTransition(const HomeScreen(), state);
    },
  ),
  GoRoute(
    path: '/events',
    pageBuilder: (context, state) {
      // Provide both EventFilterBloc and ChooseBrandDropdownBloc at this route level.
      return buildPageWithFadeTransition(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => EventFilterBloc(
                eventRepository: getIt<EventRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => ChooseBrandDropdownBloc(
                brandRepository: getIt<BrandRepository>(),
              ),
            ),
          ],
          child: EventListScreen(),
        ),
        state,
      );
    },
  ),
  GoRoute(
    path: '/scanner',
    pageBuilder: (context, state) {
      return buildPageWithFadeTransition(const ScanScreen(), state);
    },
  ),
  GoRoute(
    path: '/orders',
    pageBuilder: (context, state) {
      return buildPageWithFadeTransition(const OrganizerProfileScreen(), state);
    },
  ),
  GoRoute(
    path: '/profile',
    pageBuilder: (context, state) {
      return buildPageWithFadeTransition(const OrganizerProfileScreen(), state);
    },
  ),
];