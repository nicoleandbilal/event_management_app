import '../screens/auth/login_screen.dart';
import '../screens/discovery/discovery_page.dart';
import '../screens/home/home_screen.dart';
import 'package:flutter/material.dart';


class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) =>  HomeScreen());
      case '/event_detail':
        return MaterialPageRoute(builder: (_) =>  const EventDetailScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) =>  HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page Not Found')),
          ),
        );
    }
  }
}
