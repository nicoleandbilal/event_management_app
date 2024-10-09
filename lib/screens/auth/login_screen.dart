import 'package:event_management_app/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_management_app/blocs/auth/login_bloc.dart';
import 'package:event_management_app/repositories/auth_repository.dart';
import 'package:event_management_app/screens/auth/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Removed ..add(AppStarted())
      create: (context) => LoginBloc(authRepository: AuthRepository()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
    );
  }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state is LoginFailure && state.error.contains('email') ? state.error : null,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) => context.read<LoginBloc>().add(LoginEmailChanged(email)),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state is LoginFailure && state.error.contains('password') ? state.error : null,
          ),
          obscureText: true,
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
            final email = _emailController.text.trim();
            final password = _passwordController.text.trim();
            if (email.isNotEmpty && password.isNotEmpty) {
              context.read<LoginBloc>().add(LoginSubmitted(email, password));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter email and password')),
              );
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
          // Dispatch LoggedIn event to AuthBloc
          BlocProvider.of<AuthBloc>(context).add(LoggedIn());
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
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
          },
          child: const Text('Register'),
        ),
      ],
    );
  }
}
