// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<String> _tabs = ['/home', '/search', '/favorites', '/profile'];

   @override
   void initState() {
      super.initState();
      print('MainScreen is being rendered');  // Add a debug print
    }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    print('Navigating to ${_tabs[index]}');  // Add debug print
    context.go(_tabs[index]); // Navigate to the selected tab
  }

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentIndex = _getCurrentIndex();
  }

 int _getCurrentIndex() {
    // Access the current location via routerDelegate's currentConfiguration.uri.toString()
    final currentLocation = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();

    for (int i = 0; i < _tabs.length; i++) {
      if (currentLocation.startsWith(_tabs[i])) {
        return i;
      }
    }
    return 0; // Default to first tab if no match
  }

  @override
  Widget build(BuildContext context) {
    print('Current index: $_currentIndex');  // Add debug print
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
      ),
      body: SafeArea(
        child: widget.child
      ), // This will show the routed child
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        backgroundColor: Colors.black, // Background color of the nav bar
        selectedItemColor: Colors.white, // Selected item icon and text color
        unselectedItemColor: Colors.grey, // Unselected item icon and text color
        showUnselectedLabels: true, // Show labels for unselected items
        type: BottomNavigationBarType.fixed, // Use 'fixed' type for text and icons
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }


}
