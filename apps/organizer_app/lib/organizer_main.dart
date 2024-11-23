import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/choose_brand/choose_brand_dropdown_bloc.dart';
import 'package:organizer_app/config/router.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_bloc.dart';
import 'package:organizer_app/event_creation/event_cover_image/event_image_upload_service.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_bloc.dart';
import 'package:organizer_app/event_list/event_filter_bloc.dart';
import 'package:shared/authentication/auth/auth_bloc.dart';
import 'package:shared/authentication/auth/auth_service.dart';
import 'package:shared/config/app_theme.dart';
import 'package:shared/repositories/auth_repository.dart';
import 'package:shared/repositories/brand_repository.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/image_repository.dart';
import 'package:shared/repositories/ticket_repository.dart';
import 'package:shared/repositories/user_repository.dart';
import 'package:shared/search/bloc/search_bloc.dart';
import 'package:shared/search/search_repository.dart';

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
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<AuthService>(
          create: (context) => AuthService(context.read<AuthRepository>()),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(firestore: FirebaseFirestore.instance),
        ),
        RepositoryProvider<SearchRepository>(
          create: (context) => SearchRepository(firestore: FirebaseFirestore.instance),
        ),
        RepositoryProvider<EventRepository>(
          create: (context) => EventRepository(firestore: FirebaseFirestore.instance),
        ),
        RepositoryProvider<BrandRepository>(
          create: (context) => BrandRepository(firestore: FirebaseFirestore.instance),
        ),
        RepositoryProvider<TicketRepository>(
          create: (context) => TicketRepository(firestore: FirebaseFirestore.instance),
        ),
        RepositoryProvider<ImageRepository>(
          create: (context) => ImageRepository(storage: FirebaseStorage.instance),
        ),
        RepositoryProvider<ImageUploadService>(
          create: (context) => ImageUploadService(
            context.read<ImageRepository>(),
            _logger,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: context.read<AuthRepository>())
              ..add(AppStarted()),
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(searchRepository: context.read<SearchRepository>()),
          ),
          BlocProvider<EventFilterBloc>(
            create: (context) => EventFilterBloc(eventRepository: context.read<EventRepository>()),
          ),
          BlocProvider<ChooseBrandDropdownBloc>(
            create: (context) => ChooseBrandDropdownBloc(
              brandRepository: context.read<BrandRepository>(),
              authService: context.read<AuthService>(),
            ),
          ),
          BlocProvider<BasicDetailsBloc>(
            create: (context) => BasicDetailsBloc(
              eventRepository: context.read<EventRepository>(),
              imageUploadService: context.read<ImageUploadService>(), 
              eventId: '',
            ),
          ),
          BlocProvider<TicketDetailsBloc>(
            create: (context) => TicketDetailsBloc(
              ticketRepository: context.read<TicketRepository>(),
            ),
          ),
          BlocProvider<EventCreationBloc>(
            create: (context) => EventCreationBloc(
              eventRepository: context.read<EventRepository>(),
              ticketRepository: context.read<TicketRepository>(),
              basicDetailsBloc: context.read<BasicDetailsBloc>(),
              ticketDetailsBloc: context.read<TicketDetailsBloc>(),
              logger: Logger(),
            ),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            _logger.d('AuthBloc state changed to: $state');
            return MaterialApp.router(
              title: 'Event Management App',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              routerConfig: createGoRouter(context, state),
            );
          },
        ),
      ),
    );
  }
}
