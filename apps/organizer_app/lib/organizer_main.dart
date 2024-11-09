import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/config/router.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_bloc.dart';
import 'package:organizer_app/create_event/event_cover_image/event_image_upload_service.dart';
import 'package:organizer_app/event_list/event_filter_bloc.dart';
import 'package:organizer_app/choose_brand/choose_brand_dropdown_bloc.dart';
import 'package:shared/repositories/brand_repository.dart';
import 'package:shared/config/app_theme.dart';
import 'package:shared/repositories/auth_repository.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/image_repository.dart';
import 'package:shared/repositories/ticket_repository.dart';
import 'package:shared/repositories/user_repository.dart';
import 'package:shared/search/search_repository.dart';
import 'package:shared/search/bloc/search_bloc.dart';
import 'package:shared/authentication/auth/auth_bloc.dart';
import 'package:shared/authentication/auth/auth_service.dart';
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
        // Provide the required repositories for the app
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<AuthService>(
          create: (context) => AuthService(
            context.read<AuthRepository>(), // Provide the AuthRepository instance to AuthService
          ),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(
            firestore: FirebaseFirestore.instance, // Initialize Firestore for UserRepository
          ),
        ),
        RepositoryProvider<SearchRepository>(
          create: (context) => SearchRepository(
            firestore: FirebaseFirestore.instance, // Initialize Firestore for SearchRepository
          ),
        ),
        RepositoryProvider<EventRepository>(
          create: (context) => EventRepository(
            firestore: FirebaseFirestore.instance, // Initialize Firestore for EventRepository
          ),
        ),
        RepositoryProvider<BrandRepository>(
          create: (context) => BrandRepository(
            firestore: FirebaseFirestore.instance, // Initialize Firestore for BrandRepository
          ),
        ),
        RepositoryProvider<ImageRepository>(
          create: (context) => ImageRepository(
            storage: FirebaseStorage.instance, // Initialize FirebaseStorage for ImageRepository
          ),
        ),
        RepositoryProvider<ImageUploadService>(
          create: (context) => ImageUploadService(
            context.read<ImageRepository>(),  // Inject ImageRepository
            _logger,  // Inject Logger instance
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Provide the necessary Blocs for the app
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
          BlocProvider<EventFilterBloc>(
            create: (context) => EventFilterBloc(
              eventRepository: context.read<EventRepository>(),
            ),
          ),
          BlocProvider<ChooseBrandDropdownBloc>(
            create: (context) => ChooseBrandDropdownBloc(
              brandRepository: context.read<BrandRepository>(),
              authService: context.read<AuthService>(), // Provide authService if required
            ),
          ),
          BlocProvider<CreateEventFormBloc>(
            create: (context) => CreateEventFormBloc(
              imageUploadService: context.read<ImageUploadService>(), // Inject ImageUploadService
              eventRepository: context.read<EventRepository>(), // Inject EventRepository
              ticketRepository: context.read<TicketRepository>(), // Inject EventRepository
            ),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            _logger.d('AuthBloc state changed to: $state');  // Log AuthBloc state changes for debugging
            return MaterialApp.router(
              title: 'Event Management App',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              routerConfig: createGoRouter(context, state),  // Configure the app's router based on AuthBloc state
            );
          },
        ),
      ),
    );
  }
}
