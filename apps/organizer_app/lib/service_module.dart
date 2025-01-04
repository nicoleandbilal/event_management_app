import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/create_brand/brand_image_uploader_service.dart';
import 'package:organizer_app/event_creation/basic_details/services/basic_details_service.dart';
import 'package:shared/authentication/auth/auth_service.dart';
import 'package:organizer_app/event_creation/shared/services/event_creation_service.dart';
import 'package:organizer_app/event_creation/ticket_details/services/ticket_details_service.dart';
import 'package:organizer_app/event_creation/finishing_details/services/finishing_details_service.dart';
import 'package:shared/repositories/auth_repository.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/image_repository.dart';
import 'event_creation/basic_details/event_image_uploader/services/event_image_uploader_service.dart';

/// Registers services with the GetIt service locator
void registerServices() {
  final getIt = GetIt.instance;

  // Logger
  final logger = Logger();

  // Register services
  getIt.registerSingleton<AuthService>(
    AuthService(
      getIt<AuthRepository>(), // Pass the required parameter
      logger: logger, 
      authRepository: getIt<AuthRepository>(),
    ),
  );



  getIt.registerSingleton<BrandImageUploaderService>(
    BrandImageUploaderService(getIt<ImageRepository>()),
  );

  getIt.registerSingleton<EventCreationService>(
    EventCreationService(
      getIt<EventRepository>(), // Inject only the required dependency
    ),
  );

  getIt.registerSingleton<ImageUploadService>(
    ImageUploadService(
      getIt<ImageRepository>(), // Ensure ImageRepository is provided
      logger,
    ),
  );

  getIt.registerSingleton<BasicDetailsService>(
    BasicDetailsService(
      eventRepository: getIt<EventRepository>(), // Ensure eventRepository is provided
      logger: logger,
      imageUploadService: getIt<ImageUploadService>(), // Add the required parameter
    ),
  );

  getIt.registerSingleton<TicketDetailsService>(
    TicketDetailsService(
      ticketRepository: getIt(),
      logger: logger,
    ),
  );

  getIt.registerSingleton<FinishingDetailsService>(
    FinishingDetailsService(
      eventRepository: getIt<EventRepository>(), // Ensure eventRepository is provided
      logger: logger,
    ),
  );
}