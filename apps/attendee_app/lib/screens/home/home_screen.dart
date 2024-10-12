// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared/repositories/auth_repository.dart';

class HomeScreen extends StatelessWidget {
  final Logger _logger = Logger();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Welcome to the Home Screen!'),
        ElevatedButton(
          onPressed: () async {
            _logger.i('HomeScreen: Logout button pressed.');
            try {
              await context.read<AuthRepository>().signOut();
              _logger.i('HomeScreen: User signed out successfully.');
              // AuthBloc will automatically handle the unauthenticated state and navigate to LoginScreen
            } catch (e) {
              _logger.e('HomeScreen: Error signing out: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error signing out. Please try again.')),
              );
            }
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
