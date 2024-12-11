import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import 'package:shared/repositories/auth_repository.dart';
import 'package:shared/repositories/brand_repository.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/ticket_repository.dart';
import 'package:shared/repositories/user_repository.dart';
import 'package:shared/repositories/image_repository.dart';

/// Registers repositories with the GetIt service locator
void registerRepositories() {
  final getIt = GetIt.instance;

  // Firebase instances
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;

  // Logger
  final logger = Logger();

  // Register Logger
  getIt.registerSingleton<Logger>(logger);

    // Register FirebaseAuth
  getIt.registerSingleton<FirebaseAuth>(auth);

  // Register repositories
  getIt.registerSingleton<AuthRepository>(AuthRepository(auth, logger));
  getIt.registerSingleton<UserRepository>(UserRepository(firestore: firestore, logger: logger));
  getIt.registerSingleton<EventRepository>(EventRepository(firestore: firestore));
getIt.registerSingleton<BrandRepository>(BrandRepository(firestore: FirebaseFirestore.instance));
  getIt.registerSingleton<TicketRepository>(TicketRepository(firestore: firestore));
  getIt.registerSingleton<ImageRepository>(ImageRepository(storage: storage, logger: logger));
}