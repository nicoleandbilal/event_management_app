import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/config/router.dart';
import 'package:organizer_app/event_creation/basic_details/basic_details_service.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_bloc.dart';
import 'package:organizer_app/event_creation/event_cover_image/event_image_upload_service.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_bloc.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_event.dart';
import 'package:organizer_app/event_creation/finishing_details/finishing_details_service.dart';
import 'package:organizer_app/event_creation/save_event_service.dart';
import 'package:organizer_app/event_creation/ticket_details/ticket_details_service.dart';
import 'package:organizer_app/event_list/event_filter_bloc.dart';
import 'package:organizer_app/ticket_scanning/data/data_source/remote_data_source.dart';
import 'package:organizer_app/ticket_scanning/data/repository/ticket_repository_impl.dart';
import 'package:organizer_app/ticket_scanning/domain/use_cases/validate_ticket_use_case.dart';
import 'package:organizer_app/ticket_scanning/presentation/bloc/ticket_scan_bloc.dart';
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

/// Helper function to fetch the current user's ID using Firebase Authentication.
String? getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final userId = getCurrentUserId() ?? 'defaultUserId';

  runApp(EventManagementApp(userId: userId));
}

class EventManagementApp extends StatelessWidget {
  final String userId;

  const EventManagementApp({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final logger = Logger();

    // Create and share repositories
    final authRepository = AuthRepository();
    final userRepository = UserRepository(firestore: FirebaseFirestore.instance);
    final searchRepository = SearchRepository(firestore: FirebaseFirestore.instance);
    final eventRepository = EventRepository(firestore: FirebaseFirestore.instance);
    final brandRepository = BrandRepository(firestore: FirebaseFirestore.instance);
    final ticketRepository = TicketRepository(firestore: FirebaseFirestore.instance);
    final imageRepository = ImageRepository(storage: FirebaseStorage.instance);

    // Ticket scanning dependencies
    final ticketRemoteDataSource = TicketRemoteDataSource(firestore: FirebaseFirestore.instance);
    final ticketScanRepository = TicketRepositoryImpl(remoteDataSource: ticketRemoteDataSource);
    final validateTicketUseCase = ValidateTicketUseCase(ticketScanRepository);

    // Create services
    final imageUploadService = ImageUploadService(imageRepository, logger);
    final basicDetailsService = BasicDetailsService(
      eventRepository: eventRepository,
      imageUploadService: imageUploadService,
      logger: logger,
    );
    final ticketDetailsService = TicketDetailsService(
      ticketRepository: ticketRepository,
      logger: logger,
    );
    final saveEventService = SaveEventService(
      basicDetailsService: basicDetailsService,
      ticketDetailsService: ticketDetailsService,
      finishingDetailsService: FinishingDetailsService(eventRepository: eventRepository),
      eventRepository: eventRepository,
      ticketRepository: ticketRepository,
      logger: logger,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Logger>.value(value: logger),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<AuthService>(
          create: (context) => AuthService(authRepository),
        ),
        RepositoryProvider<UserRepository>.value(value: userRepository),
        RepositoryProvider<SearchRepository>.value(value: searchRepository),
        RepositoryProvider<EventRepository>.value(value: eventRepository),
        RepositoryProvider<BrandRepository>.value(value: brandRepository),
        RepositoryProvider<TicketRepository>.value(value: ticketRepository),
        RepositoryProvider<ImageRepository>.value(value: imageRepository),
        RepositoryProvider<ImageUploadService>.value(value: imageUploadService),
        RepositoryProvider<BasicDetailsService>.value(value: basicDetailsService),
        RepositoryProvider<TicketDetailsService>.value(value: ticketDetailsService),
        RepositoryProvider<SaveEventService>.value(value: saveEventService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(authRepository: authRepository)..add(AppStarted()),
          ),
          BlocProvider<SearchBloc>(
            create: (_) => SearchBloc(searchRepository: searchRepository),
          ),
          BlocProvider<EventCreationBloc>(
            create: (_) => EventCreationBloc(
              saveEventService: saveEventService,
              logger: logger,
            )..add(InitializeEventCreation(userId)),
          ),
          BlocProvider<EventFilterBloc>(
            create: (_) => EventFilterBloc(eventRepository: eventRepository),
          ),
          BlocProvider<BasicDetailsBloc>(
            create: (_) => BasicDetailsBloc(
              basicDetailsService: basicDetailsService,
              eventId: '',
              logger: logger,
            ),
          ),
          // TicketScanBloc for the scanning feature
          BlocProvider<TicketScanBloc>(
            create: (_) => TicketScanBloc(validateTicketUseCase: validateTicketUseCase),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state == null) {
              return const Center(child: CircularProgressIndicator());
            }
            logger.d('AuthBloc state changed to: $state');
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