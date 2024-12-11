import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:get_it/get_it.dart';
import 'package:organizer_app/create_brand/blocs/create_brand_form_bloc.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_event.dart';
import 'package:shared/authentication/login/login_bloc.dart';
import 'package:shared/authentication/register/registration_bloc.dart';
import 'package:shared/config/app_theme.dart';
import 'package:organizer_app/config/router.dart';
import 'package:shared/authentication/auth/auth_bloc.dart';
import 'package:shared/authentication/auth/auth_service.dart';
import 'package:shared/repositories/auth_repository.dart';
import 'package:shared/repositories/user_repository.dart';
import 'package:shared/search/bloc/search_bloc.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/blocs/basic_details_bloc.dart';
import 'package:organizer_app/ticket_scanning/presentation/bloc/ticket_scan_bloc.dart';

import 'repository_module.dart';
import 'service_module.dart';

/// Entry point of the application
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    Logger().e('Firebase initialization failed: $e');
    rethrow;
  }

  // Register dependencies
  registerRepositories();
  registerServices();

  final authService = GetIt.instance<AuthService>();
  final userId = authService.getCurrentUserId();

  if (userId == null) {
    Logger().e('No authenticated user found.');
    // Handle navigation to login here if required.
  }

  runApp(EventManagementApp(userId: userId ?? ''));
}

class EventManagementApp extends StatelessWidget {
  final String userId;

  const EventManagementApp({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final logger = GetIt.instance<Logger>();

  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(
          GetIt.instance<AuthService>(),
          authRepository: GetIt.instance<AuthRepository>(),
        )..add(AppStarted()),
      ),
      BlocProvider<SearchBloc>(
        create: (_) => SearchBloc(
          searchRepository: GetIt.instance(),
        ),
      ),
      BlocProvider<EventCreationBloc>(
        create: (_) => EventCreationBloc(
          GetIt.instance(),
          eventCreationService: GetIt.instance(),
        )..add(InitializeEventCreation(userId)),
      ),
      BlocProvider<BasicDetailsBloc>(
        create: (_) => BasicDetailsBloc(
          service: GetIt.instance(),
          logger: GetIt.instance<Logger>(),
        ),
      ),
      BlocProvider<TicketScanBloc>(
        create: (_) => TicketScanBloc(
          validateTicketUseCase: GetIt.instance(),
        ),
      ),
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
          authRepository: GetIt.instance<AuthRepository>(),
          authBloc: context.read<AuthBloc>(),
        ),
      ),
      BlocProvider<RegistrationBloc>(
        create: (_) => RegistrationBloc(
          authRepository: GetIt.instance<AuthRepository>(),
          userRepository: GetIt.instance<UserRepository>(),
        ),
      ),
    ],
    child: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state == null) {
          return const Center(child: CircularProgressIndicator());
        }
        GetIt.instance<Logger>().d('AuthBloc state changed to: $state');
        return MaterialApp.router(
          title: 'Event Management App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: createGoRouter(context, state),
        );
      },
    ),
  );
 }
}