// lib/screens/auth/login_screen.dart

import 'package:event_management_app/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_management_app/blocs/auth/login_bloc.dart';
import 'package:event_management_app/repositories/auth_repository.dart';
import 'package:event_management_app/screens/auth/registration_screen.dart';
import 'package:logger/logger.dart'; // Import the logger package

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Logger _logger = Logger(); // Initialize logger

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authRepository: context.read<AuthRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form( // Wrap with Form
            key: _formKey, // Assign the key
            child: Column(
              children: [
                _emailField(),
                _passwordField(),
                const SizedBox(height: 20),
                _loginButton(),
                _loginStatus(),
                const SizedBox(height: 20),
                _navigateToRegister(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField( // Use TextFormField
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state is LoginFailure && state.error.contains('email') ? state.error : null,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) { // Add validator
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          onChanged: (email) => context.read<LoginBloc>().add(LoginEmailChanged(email)),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField( // Use TextFormField
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state is LoginFailure && state.error.contains('password') ? state.error : null,
          ),
          obscureText: true,
          validator: (value) { // Add validator
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
          onChanged: (password) => context.read<LoginBloc>().add(LoginPasswordChanged(password)),
        );
      },
    );
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginLoading) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) { // Validate form
              final email = _emailController.text.trim();
              final password = _passwordController.text.trim();
              context.read<LoginBloc>().add(LoginSubmitted(email, password));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fix the errors in red before submitting.')),
              );
              _logger.w('LoginScreen: Form validation failed.');
            }
          },
          child: const Text('Login'),
        );
      },
    );
  }

  Widget _loginStatus() {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          _logger.i('LoginScreen: Login successful. AuthBloc will emit Authenticated state.');
          // No need to dispatch LoggedIn event
          // Navigation is handled by AuthBloc's state change in main.dart
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
          _logger.e('LoginScreen: Login failed with error: ${state.error}');
        }
      },
      child: Container(),
    );
  }

  Widget _navigateToRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Don\'t have an account?'),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegistrationScreen()),
            );
            _logger.i('LoginScreen: Navigating to RegistrationScreen.');
          },
          child: const Text('Register'),
        ),
      ],
    );
  }
}
