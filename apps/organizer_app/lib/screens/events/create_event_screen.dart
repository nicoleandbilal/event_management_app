import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/blocs/create_event/create_event_form_bloc.dart';
import 'package:organizer_app/widgets/create_event_form.dart';
import 'package:organizer_app/repositories/create_event_repository.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the repository through GoRouter's extra or directly if passed down
    final createEventRepository = context.read<CreateEventRepository>();

    return BlocProvider(
      create: (context) => CreateEventFormBloc(createEventRepository),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Event'),
        ),
        body: BlocListener<CreateEventFormBloc, CreateEventFormState>(
          listener: (context, state) {
            if (state is CreateEventFormSuccess) {
              Navigator.of(context).pop(); // Navigate back after success
            } else if (state is CreateEventFormFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: CreateEventForm(), // The form where user fills out event details
          ),
        ),
      ),
    );
  }
}
