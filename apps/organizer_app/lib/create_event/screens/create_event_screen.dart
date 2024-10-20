// create_event_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_bloc.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_state.dart';
import 'package:organizer_app/widgets/create_event_form.dart';
import 'package:organizer_app/create_event/repositories/create_event_repository.dart';

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

    return BlocProvider(
      create: (context) => CreateEventFormBloc(createEventRepository),
      child: BlocListener<CreateEventFormBloc, CreateEventFormState>(
        listener: (context, state) {
          if (state is CreateEventFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event created successfully!')),
          );
          
          // Instead of popping, navigate to a specific screen, such as home or event list
          context.go('/favorites');  // Assuming '/home' is the route to your main/home screen
}
        },
        child: Scaffold(
          appBar: AppBar(
          ),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: CreateEventForm(), // The form widget for creating an event
          ),
        ),
      ),
    );
  }
}
