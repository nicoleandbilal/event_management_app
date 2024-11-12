import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/config/router.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_bloc.dart';
import 'package:organizer_app/create_event/event_cover_image/event_image_upload_service.dart';
import 'package:organizer_app/create_event/event_details/bloc/event_details_bloc.dart';
import 'package:organizer_app/create_event/ticketing/bloc/ticket_details_bloc.dart';
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
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(EventManagementApp());
}

class EventManagementApp extends StatelessWidget {
  final Logger _logger = Logger();

  EventManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Provide repositories for the app
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<AuthService>(
          create: (context) => AuthService(
            context.read<AuthRepository>(), // AuthRepository for AuthService
          ),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(
            firestore: FirebaseFirestore.instance, // Firestore for UserRepository
          ),
        ),
        RepositoryProvider<SearchRepository>(
          create: (context) => SearchRepository(
            firestore: FirebaseFirestore.instance, // Firestore for SearchRepository
          ),
        ),
        RepositoryProvider<EventRepository>(
          create: (context) => EventRepository(
            firestore: FirebaseFirestore.instance, // Firestore for EventRepository
          ),
        ),
        RepositoryProvider<BrandRepository>(
          create: (context) => BrandRepository(
            firestore: FirebaseFirestore.instance, // Firestore for BrandRepository
          ),
        ),
        RepositoryProvider<TicketRepository>(
          create: (context) => TicketRepository(
            firestore: FirebaseFirestore.instance, // Firestore for TicketRepository
          ),
        ),
        RepositoryProvider<ImageRepository>(
          create: (context) => ImageRepository(
            storage: FirebaseStorage.instance, // FirebaseStorage for ImageRepository
          ),
        ),
        RepositoryProvider<ImageUploadService>(
          create: (context) => ImageUploadService(
            context.read<ImageRepository>(), // Inject ImageRepository
            _logger, // Inject Logger instance
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Provide necessary Blocs for the app
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AppStarted()), // Trigger initial auth check
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
              authService: context.read<AuthService>(), // Provide AuthService if required
            ),
          ),
          BlocProvider<EventDetailsBloc>(
            create: (context) => EventDetailsBloc(
              eventRepository: context.read<EventRepository>(),
              imageRepository: context.read<ImageRepository>(),
            ),
          ),
          BlocProvider<TicketDetailsBloc>(
            create: (context) => TicketDetailsBloc(
              ticketRepository: context.read<TicketRepository>(),
            ),
          ),
          BlocProvider<CreateEventFormBloc>(
            create: (context) => CreateEventFormBloc(
              eventDetailsBloc: context.read<EventDetailsBloc>(), // Inject EventDetailsBloc
              ticketDetailsBloc: context.read<TicketDetailsBloc>(), // Inject TicketDetailsBloc
            ),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            _logger.d('AuthBloc state changed to: $state'); // Log AuthBloc state changes
            return MaterialApp.router(
              title: 'Event Management App',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              routerConfig: createGoRouter(context, state), // Configure router based on AuthBloc state
            );
          },
        ),
      ),
    );
  }
}
