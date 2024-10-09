import 'package:event_management_app/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:event_management_app/screens/home/home_screen.dart';
import 'package:event_management_app/screens/event_detail/event_detail_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/event_detail':
        return MaterialPageRoute(builder: (_) => const EventDetailScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page Not Found')),
          ),
        );
    }
  }
}
