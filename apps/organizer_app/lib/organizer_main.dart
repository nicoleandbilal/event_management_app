import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/config/router.dart';  // Your new router config file
import 'package:shared/config/app_theme.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/auth_repository.dart';
import 'package:shared/repositories/user_repository.dart';  // Import UserRepository
import 'package:shared/search/search_repository.dart';
import 'package:shared/search/bloc/search_bloc.dart';
import 'package:shared/authentication/auth/auth_bloc.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(EventManagementApp());
}

class EventManagementApp extends StatelessWidget {
  final Logger _logger = Logger();

  EventManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(
            firestore: FirebaseFirestore.instance,  // Inject FirebaseFirestore instance
          ),
        ),
        RepositoryProvider<SearchRepository>(
          create: (context) => SearchRepository(
            firestore: FirebaseFirestore.instance,  // Inject FirebaseFirestore instance
          ),
        ),
        RepositoryProvider<EventRepository>(
          create: (context) => EventRepository(
            firestore: FirebaseFirestore.instance,  // Inject FirebaseFirestore instance
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AppStarted()),  // Trigger initial authentication check
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(
              searchRepository: context.read<SearchRepository>(),
            ),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            _logger.d('AuthBloc state changed to: $state');
            return MaterialApp.router(
              title: 'Event Management App',
              debugShowCheckedModeBanner: false,  // Hide the debug banner
              theme: AppTheme.lightTheme,         // Use the light theme
              routerConfig: createGoRouter(context, state),  // Use the new GoRouter configuration
            );
          },
        ),
      ),
    );
  }
}
