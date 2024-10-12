// lib/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/blocs/auth/auth_bloc.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Handles the logout event by dispatching LoggedOut event to the AuthBloc
  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(LoggedOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context),
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
