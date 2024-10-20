import 'package:attendee_app/utils/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logger.i('HomeScreen: Logout button pressed.');
              context.read<AuthBloc>().add(LoggedOut()); // Trigger the logout event in AuthBloc
            },
          ),
        ],
      ),
      body: SafeArea(
        child: widget.child, // Show the routed child content here
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTabChange: _onTap, // Pass the callback to handle tab change
      ),
    );
  }
}
