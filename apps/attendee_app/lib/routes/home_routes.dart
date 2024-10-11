// lib/routes/home_routes.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:attendee_app/screens/home/home_screen.dart';  // Assuming you have this screen

List<GoRoute> homeRoutes = [
  GoRoute(
    path: '/home',
    builder: (context, state) => HomeScreen(),
  ),
];
