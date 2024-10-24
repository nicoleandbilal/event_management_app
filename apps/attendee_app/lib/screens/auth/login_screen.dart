import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/authentication/auth/auth_bloc.dart'; // Import AuthBloc
import 'package:shared/repositories/auth_repository.dart';
import 'package:shared/authentication/login/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  final String? email;  // Accept email as an optional parameter to pre-fill the email field

  const LoginScreen({super.key, this.email});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailPreFilled = false;

  @override
  void initState() {
    super.initState();

    // If the email is passed from the CheckerScreen, pre-fill the email field
    if (widget.email != null && widget.email!.isNotEmpty) {
      _emailController.text = widget.email!;
      _isEmailPreFilled = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Retrieve the recognized email from AuthBloc if passed via AuthBloc state
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthEmailRecognized && authState.email.isNotEmpty && !_isEmailPreFilled) {
      _emailController.text = authState.email;
      setState(() {
        _isEmailPreFilled = true; // Mark the email as pre-filled
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        authRepository: context.read<AuthRepository>(),
        authBloc: context.read<AuthBloc>(),
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
                            _welcomeBackText(),
                            _welcomeBackSubText(),
                            const SizedBox(height: 16),
                            _emailField(),  // Email field with updated styling
                            const SizedBox(height: 16),
                            _passwordField(),
                            const SizedBox(height: 16),
                            _loginButton(),
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

  // Welcome back text
  Widget _welcomeBackText() {
    return const Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        'Welcome back, Guest.',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Welcome back subtext
  Widget _welcomeBackSubText() {
    return const Padding(
      padding: EdgeInsets.all(14.0),
      child: Text(
        'Enter your email to continue',
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Email input field
  Widget _emailField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(color: _isEmailPreFilled ? Colors.green : Colors.grey), // Change color if pre-filled
        color: _isEmailPreFilled ? Colors.green.withOpacity(0.2) : Colors.transparent, // Light green background if pre-filled
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

  // Password input field
  Widget _passwordField() {
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
            'Password',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Login button
  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginLoading) {
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
              context.read<LoginBloc>().add(
                    LoginSubmitted(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    ),
                  );
            }
          },
          child: const Text('Get Started'),
        );
      },
    );
  }

  // "or" divider
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

  // Facebook login button
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

  // Register navigation button
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

  // Login error widget
  Widget _loginError() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginFailure) {
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
