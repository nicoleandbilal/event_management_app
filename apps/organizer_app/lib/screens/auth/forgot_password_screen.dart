// lib/screens/auth/forgot_password_screen.dart

import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement your forgot password screen here
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: const Center(
        child: Text('Forgot Password Screen'),
      ),
    );
  }
}
