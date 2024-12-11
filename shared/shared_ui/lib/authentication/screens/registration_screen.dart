import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/authentication/auth/auth_bloc.dart';
import 'package:shared/repositories/auth_repository.dart';
import 'package:shared/authentication/register/registration_bloc.dart';
import 'package:shared/widgets/custom_label_input_box.dart';
import 'package:shared/repositories/user_repository.dart';

class RegistrationScreen extends StatefulWidget {
  final String? email;

  const RegistrationScreen({super.key, this.email});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isEmailPreFilled = false;

  @override
  void initState() {
    super.initState();

    if (widget.email != null && widget.email!.isNotEmpty) {
      _emailController.text = widget.email!;
      _isEmailPreFilled = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthEmailRecognized && authState.email.isNotEmpty && !_isEmailPreFilled) {
      _emailController.text = authState.email;
      setState(() {
        _isEmailPreFilled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => RegistrationBloc(
    authRepository: GetIt.instance<AuthRepository>(),
    userRepository: GetIt.instance<UserRepository>(),
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
                            _createAccountText(),
                            _createAccountSubText(),
                            const SizedBox(height: 16),
                            _nameFields(),
                            const SizedBox(height: 16),
                            CustomLabelInputBox(
                              labelText: 'Email Address',
                              validationMessage: 'Please enter your email',
                              controller: _emailController,
                              obscureText: false,
                            ),
                            const SizedBox(height: 16),
                            CustomLabelInputBox(
                              labelText: 'Password',
                              validationMessage: 'Please enter your password',
                              controller: _passwordController,
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            CustomLabelInputBox(
                              labelText: 'Confirm Password',
                              validationMessage: 'Please confirm your password',
                              controller: _confirmPasswordController,
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            _registerButton(),
                          ],
                        ),
                      ),
                      _orDivider(),
                      _facebookSignUpButton(),
                      const SizedBox(height: 20),
                      _navigateToLogin(),
                      const SizedBox(height: 16),
                      _registerError(),
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

  // Welcome back text
  Widget _createAccountText() {
    return const Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        'Create Account',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Subtext for creating an account
  Widget _createAccountSubText() {
    return const Padding(
      padding: EdgeInsets.all(14.0),
      child: Text(
        'Enter your details to continue',
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // First Name and Last Name fields in a single row
  Widget _nameFields() {
    return Row(
      children: [
        Expanded(
          child: CustomLabelInputBox(
            labelText: 'First Name',
            validationMessage: 'Please enter your first name',
            controller: _firstNameController,
            obscureText: false,
          ),
        ),
        const SizedBox(width: 16), // Add space between the fields
        Expanded(
          child: CustomLabelInputBox(
            labelText: 'Last Name',
            validationMessage: 'Please enter your last name',
            controller: _lastNameController,
            obscureText: false,
          ),
        ),
      ],
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
              if (_passwordController.text != _confirmPasswordController.text) {
                // Show password mismatch error
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }
              context.read<RegistrationBloc>().add(
                    RegistrationSubmitted(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      firstName: _firstNameController.text.trim(),
                      lastName: _lastNameController.text.trim(),
                    ),
                  );
            }
          },
          child: const Text('Get Started'),
        );
      },
    );
  }

  // "or" divider between signup methods
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

  // Facebook signup button
  Widget _facebookSignUpButton() {
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
        // Handle Facebook signup logic
      },
      label: const Text('Sign up with Facebook'),
    );
  }

  // Navigate to login screen
  Widget _navigateToLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Have an account?"),
        TextButton(
          onPressed: () {
            context.go('/login');
          },
          child: const Text('Login'),
        ),
      ],
    );
  }

  // Registration error message
  Widget _registerError() {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        if (state is RegistrationFailure) {
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
}
