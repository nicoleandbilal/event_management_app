// email_checker_screen.dart

/*

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/blocs/all_auth/email_checker/email_checker_bloc.dart';
import 'package:shared/blocs/all_auth/email_checker/email_checker_event.dart';
import 'package:shared/blocs/all_auth/email_checker/email_checker_state.dart';
import 'package:shared/repositories/auth_repository.dart';
import 'package:shared/blocs/all_auth/auth/auth_bloc.dart';

class CheckerScreen extends StatefulWidget {
  const CheckerScreen({super.key});

  @override
  CheckerScreenState createState() => CheckerScreenState();
}

class CheckerScreenState extends State<CheckerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailCheckerBloc(
        authRepository: context.read<AuthRepository>(),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 500,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      blurRadius: 50,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 16.0, left: 26.0, right: 26.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 16),
                            _welcomeOptionsText(),
                            _welcomeOptionsSubText(),
                            const SizedBox(height: 16),
                            _emailField(),
                            const SizedBox(height: 16),
                            _nextButton(), // Updated logic for email checking
                          ],
                        ),
                      ),
                      _orDivider(),
                      _facebookLoginButton(),
                      const SizedBox(height: 20),
                      _navigateToRegister(),
                      const SizedBox(height: 16),
                      _loginError(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Button that triggers email checking logic and navigates
  Widget _nextButton() {
    return BlocConsumer<EmailCheckerBloc, EmailCheckerState>(
      listener: (context, state) {
        if (state is EmailCheckSuccess) {
          final email = _emailController.text.trim(); // Get the email from the form
          context.read<AuthBloc>().add(EmailRecognized(email: email)); // Dispatch email to AuthBloc

          // Navigation based on whether the email is registered
          if (state.isRegistered) {
            print('CheckerScreen: User is registered, navigating to login with email: $email');
            context.go('/login', extra: email);  // Pass email to LoginScreen
          } else {
            print('CheckerScreen: User is not registered, navigating to register with email: $email');
            context.go('/register', extra: email);  // Pass email to RegistrationScreen
          }
        } else if (state is EmailCheckFailure) {
          print('CheckerScreen: Error: ${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is EmailCheckLoading) {
          return const CircularProgressIndicator(); // Show loading indicator
        }

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            minimumSize: const Size(double.infinity, 40),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final email = _emailController.text.trim();
              print('CheckerScreen: Checking if email is registered: $email');
              context.read<EmailCheckerBloc>().add(CheckEmailEvent(email));  // Trigger the event here
            }
          },
          child: const Text('Next'),
        );
      },
    );
  }

  // Display any login errors or email check failures
  Widget _loginError() {
    return BlocBuilder<EmailCheckerBloc, EmailCheckerState>(
      builder: (context, state) {
        if (state is EmailCheckFailure) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              state.error,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _welcomeOptionsText() {
    return const Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        'Sign up or Log in',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _welcomeOptionsSubText() {
    return const Padding(
      padding: EdgeInsets.all(14.0),
      child: Text(
        'Enter email to continue',
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _emailField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.fromLTRB(6, 4, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Email Address',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          TextFormField(
            controller: _emailController,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _orDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'or',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _facebookLoginButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.0),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 40),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      icon: const Icon(Icons.facebook),
      onPressed: () {
        // Handle Facebook login logic here
      },
      label: const Text('Continue with Facebook'),
    );
  }

  Widget _navigateToRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            context.go('/register');
          },
          child: const Text('Register'),
        ),
      ],
    );
  }
}

*/