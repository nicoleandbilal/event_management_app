import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_bloc.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_state.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/image_repository.dart';
import 'package:organizer_app/create_event/event_image_upload_service.dart';
import 'package:organizer_app/create_event/widgets/create_event_form.dart';

class CreateEventScreen extends StatelessWidget {
  final String brandId;

  // Update constructor to require brandId
  const CreateEventScreen({super.key, required this.brandId});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<EventRepository>(
          create: (context) => EventRepository(
            firestore: FirebaseFirestore.instance,
          ),
        ),
        RepositoryProvider<ImageRepository>(
          create: (context) => ImageRepository(
            storage: FirebaseStorage.instance,
          ),
        ),
        RepositoryProvider<ImageUploadService>(
          create: (context) => ImageUploadService(
            RepositoryProvider.of<ImageRepository>(context),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => CreateEventFormBloc(
          RepositoryProvider.of<EventRepository>(context),
          RepositoryProvider.of<ImageUploadService>(context),
        ),
        child: BlocListener<CreateEventFormBloc, CreateEventFormState>(
          listener: (context, state) {
            if (state is CreateEventFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event created successfully!')),
              );
              context.go('/events');
            } else if (state is CreateEventFormFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Create Event'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: CreateEventForm(brandId: brandId), // Pass brandId here
              ),
            ),
          ),
        ),
      ),
    );
  }
}
