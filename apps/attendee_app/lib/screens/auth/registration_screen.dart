import 'package:attendee_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/blocs/auth/registration_bloc.dart';
import 'package:shared/repositories/auth_repository.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(authRepository: AuthRepository()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _emailField(),
              _passwordField(),
              const SizedBox(height: 20),
              _registerButton(),
              _registrationStatus(),
              const SizedBox(height: 20),
              _navigateToLogin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        return TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state is RegistrationFailure && state.error.contains('email') ? state.error : null,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) => context.read<RegistrationBloc>().add(RegistrationEmailChanged(email)),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        return TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state is RegistrationFailure && state.error.contains('password') ? state.error : null,
          ),
          obscureText: true,
          onChanged: (password) => context.read<RegistrationBloc>().add(RegistrationPasswordChanged(password)),
        );
      },
    );
  }

  Widget _registerButton() {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        if (state is RegistrationLoading) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          onPressed: () {
            final email = _emailController.text.trim();
            final password = _passwordController.text.trim();
            if (email.isNotEmpty && password.isNotEmpty) {
              context.read<RegistrationBloc>().add(RegistrationSubmitted(email, password));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter email and password')),
              );
            }
          },
          child: const Text('Register'),
        );
      },
    );
  }

  Widget _registrationStatus() {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else if (state is RegistrationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Container(),
    );
  }

  Widget _navigateToLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?'),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
