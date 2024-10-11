import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/config/app_router.dart';
import 'package:organizer_app/config/app_theme.dart';
import 'package:shared/blocs/auth/auth_bloc.dart';
import 'package:shared/blocs/navigation/navigation_bloc.dart';
import 'package:shared/repositories/auth_repository.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'package:logger/logger.dart'; // Import the logger package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(EventManagementApp());
}

class EventManagementApp extends StatelessWidget {
  final Logger _logger = Logger();

  EventManagementApp({super.key}); // Initialize the logger

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(), // Provide AuthRepository
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: context.read<AuthRepository>())..add(AppStarted()),
          ),
          BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc(),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            _logger.d('main.dart: AuthBloc state changed to: $state');
            return MaterialApp(
              title: 'Event Management App',
              theme: AppTheme.lightTheme,
              onGenerateRoute: AppRouter.onGenerateRoute,
              home: _getInitialScreen(state),
            );
          },
        ),
      ),
    );
  }

  Widget _getInitialScreen(AuthState state) {
    if (state is Authenticated) {
      _logger.i('main.dart: User is authenticated. Navigating to HomeScreen.');
      return HomeScreen();
    } else if (state is Unauthenticated) {
      _logger.i('main.dart: User is unauthenticated. Navigating to LoginScreen.');
      return LoginScreen();
    } else {
      _logger.w('main.dart: Authentication state is loading.');
      // Show a loading screen while checking authentication state
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}