// create_event_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_bloc.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_state.dart';
import 'package:organizer_app/widgets/create_event_form.dart';
import 'package:organizer_app/create_event/repositories/create_event_repository.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Add Firebase storage for uploading images

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  @override
  Widget build(BuildContext context) {
    // Ensure that CreateEventRepository is provided in the context
    final createEventRepository = RepositoryProvider.of<CreateEventRepository>(context);
    final firebaseStorage = FirebaseStorage.instance;  // Add FirebaseStorage instance

    return BlocProvider(
      create: (context) => CreateEventFormBloc(createEventRepository, firebaseStorage),
      child: BlocListener<CreateEventFormBloc, CreateEventFormState>(
        listener: (context, state) {
          if (state is CreateEventFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event created successfully!')),
            );
          
            // Instead of popping, navigate to a specific screen, such as home or event list
            context.go('/favorites');  // Assuming '/favorites' is the route to the next screen
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Create Event'),
          ),
          body: const Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: CreateEventForm(), // The form widget for creating an event
            ),
          ),
        ),
      ),
    );
  }
}
