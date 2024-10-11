// lib/organizer_main.dart

import 'package:attendee_app/config/app_theme.dart';
import 'package:attendee_app/config/router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/blocs/auth/auth_bloc.dart';
import 'package:shared/repositories/auth_repository.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EventManagementApp());
}

class EventManagementApp extends StatelessWidget {
  final Logger _logger = Logger();

  EventManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AppStarted()),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            _logger.d('Main AuthBloc state changed to: $state');
            return MaterialApp.router(
              title: 'Event Management App',
              theme: AppTheme.lightTheme,
              routerConfig: createGoRouter(context, state),
            );
          },
        ),
      ),
    );
  }
}