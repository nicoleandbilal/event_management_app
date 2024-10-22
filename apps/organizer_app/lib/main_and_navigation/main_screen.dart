// main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/main_and_navigation/main_navigation_bloc.dart';
import 'package:organizer_app/main_and_navigation/custom_bottom_nav_bar.dart';
import 'package:logger/logger.dart';
import 'package:shared/authentication/auth/auth_bloc.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainNavigationBloc, MainNavigationState>(
      builder: (context, state) {
        // Cast state to TabSelectedState to access its fields
        final tabState = state as TabSelectedState;
        final mainNavBloc = context.read<MainNavigationBloc>();

        return Scaffold(
          appBar: tabState.isFullScreenRoute ? null : _buildAppBar(context, tabState.currentIndex),
          body: SafeArea(child: child),
          bottomNavigationBar: tabState.isFullScreenRoute
              ? null
              : CustomBottomNavBar(
                  currentIndex: tabState.currentIndex,
                  onTabChange: (index) {
                    context.read<MainNavigationBloc>().add(TabSelectedEvent(index));
                    final route = mainNavBloc.getRoute(index);
                    context.go(route); // Navigate to the selected tab
                  },
                ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, int currentIndex) {
    final mainNavBloc = context.read<MainNavigationBloc>();
    return AppBar(
      title: Text(mainNavBloc.getAppBarTitle(currentIndex)),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Logger().i('Logout button pressed.');
            context.read<AuthBloc>().add(LoggedOut());
          },
        ),
      ],
    );
  }
}
