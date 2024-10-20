/*

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/blocs/auth/registration_bloc.dart';
import 'package:shared/repositories/auth_repository.dart';


class RegistrationScreen extends StatefulWidget {
  final String? email;  // Accept email as an optional parameter to pre-fill the email field

  const RegistrationScreen({super.key, this.email});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // If the email is passed from the CheckerScreen, pre-fill the email field
    if (widget.email != null && widget.email!.isNotEmpty) {
      _emailController.text = widget.email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(authRepository: context.read<AuthRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _emailField(),
                const SizedBox(height: 16),
                _passwordField(),
                const SizedBox(height: 20),
                _registerButton(),
                const SizedBox(height: 20),
                _navigateToLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Email input field
  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  // Password input field
  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  // Register button
  Widget _registerButton() {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        if (state is RegistrationLoading) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<RegistrationBloc>().add(
                    RegistrationSubmitted(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    ),
                  );
            }
          },
          child: const Text('Register'),
        );
      },
    );
  }

  // Navigate to login link
  Widget _navigateToLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?'),
        TextButton(
          onPressed: () {
            context.go('/login');
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}

*/