import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/utils/custom_bottom_nav_bar.dart';
import 'package:logger/logger.dart';
import 'package:shared/authentication/auth/auth_bloc.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final Logger _logger = Logger();
  int _currentIndex = 0;

  // Define the routes for each tab in the navigation bar
  final List<String> _tabs = ['/home', '/search', '/favorites', '/profile'];

  // List of full-screen routes (to hide AppBar and BottomNavigationBar)
  final List<String> fullScreenRoutes = ['/create_event', '/edit_event', '/view_event'];

  @override
  void initState() {
    super.initState();
    _logger.i('MainScreen is being rendered');
  }

  // Handle tab selection
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _logger.i('Navigating to ${_tabs[index]}');
    context.go(_tabs[index]); // Navigate to the selected tab
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('Current index: $_currentIndex');

    // Dynamically detect if the current route is a full-screen route
    final currentRoute = GoRouterState.of(context).uri.toString();
    final bool isFullScreenRoute = fullScreenRoutes.contains(currentRoute);

    return Scaffold(
      appBar: isFullScreenRoute
          ? null // Hide AppBar for full-screen routes
          : AppBar(
              title: Text(_getAppBarTitle(currentRoute)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    _logger.i('MainScreen: Logout button pressed.');
                    context.read<AuthBloc>().add(LoggedOut()); // Trigger the logout event in AuthBloc
                  },
                ),
              ],
            ),
      body: SafeArea(
        child: widget.child, // Show the routed child content here
      ),
      bottomNavigationBar: isFullScreenRoute
          ? null // Hide BottomNavigationBar for full-screen routes
          : CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTabChange: _onTap, // Pass the callback to handle tab change
            ),
    );
  }

  // Method to get AppBar title based on the current route
  String _getAppBarTitle(String route) {
    switch (route) {
      case '/home':
        return 'Home';
      case '/search':
        return 'Search';
      case '/favorites':
        return 'Favorites';
      case '/profile':
        return 'Profile';
      // Add other routes as needed
      default:
        return 'App Title';
    }
  }
}