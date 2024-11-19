import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/basic_details_screen.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_bloc.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_bloc.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_event.dart';
import 'package:organizer_app/event_creation/event_creation_bloc/event_creation_state.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_bloc.dart';
import 'package:shared/models/event_model.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/ticket_repository.dart';

class EventCreationScreen extends StatelessWidget {
  final String userId;
  final String brandId;

  const EventCreationScreen({
    Key? key,
    required this.userId,
    required this.brandId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCreationBloc(
        eventRepository: context.read<EventRepository>(),
        ticketRepository: context.read<TicketRepository>(),
        basicDetailsBloc: context.read<BasicDetailsBloc>(),
        ticketDetailsBloc: context.read<TicketDetailsBloc>(),
      )..add(InitializeEventCreation(userId)),
      child: Stack(
        children: [
          // Blurred Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Event Creation Modal
          const EventCreationModal(),
        ],
      ),
    );
  }
}

class EventCreationModal extends StatelessWidget {
  const EventCreationModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<EventCreationBloc, EventCreationState>(
        listener: (context, state) {
          if (state is EventCreationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is EventCreationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventCreationLoaded) {
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      _buildTopBar(context),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: _buildContent(context, state),
                        ),
                      ),
                      _buildBottomNavigation(context, state),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Initializing..."));
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              final currentState =
                  context.read<EventCreationBloc>().state as EventCreationLoaded;
              context.read<EventCreationBloc>().add(SaveAndExit(
                    currentState.eventId,
                    {}, // Provide updated form data
                  ));
              Navigator.pop(context);
            },
            child: const Text("Save & Exit"),
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Need Help?"),
                    content: const Text("Visit our FAQ page or contact support."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text("Questions?"),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, EventCreationLoaded state) {
    switch (state.currentStep) {
      case 0:
        return const Center(child: Text("Splash/Intro Screen"));
      case 1:
        return BasicDetailsScreen(
          eventId: state.eventId,
          onUpdateFormData: (formData) {
            context.read<EventCreationBloc>().add(NextStep(formData: formData));
          },
        );
      case 2:
        return Center(
          child: Column(
            children: const [
              Text("Additional Steps Here"),
              Text("e.g., Ticket Details"),
            ],
          ),
        );
      default:
        return Center(child: Text("Step ${state.currentStep}"));
    }
  }

  Widget _buildBottomNavigation(BuildContext context, EventCreationLoaded state) {
    final isLastStep = state.currentStep == 2;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (state.currentStep > 0)
            TextButton(
              onPressed: () {
                context.read<EventCreationBloc>().add(PreviousStep());
              },
              child: const Text("Back"),
            ),
          ElevatedButton(
            onPressed: () {
              if (isLastStep) {
                final event = Event(
                  eventId: '',
                  createdByUserId: '',
                  eventName: "Sample Event",
                  description: "Sample Description",
                  category: "Sample Category",
                  startDateTime: DateTime.now(),
                  endDateTime: DateTime.now().add(const Duration(hours: 2)),
                  venue: "Sample Venue",
                  status: "draft",
                  createdAt: DateTime.now(),
                );
                context.read<EventCreationBloc>().add(PublishEvent(event));
              } else {
                context.read<EventCreationBloc>().add(NextStep());
              }
            },
            child: Text(isLastStep ? "Finish" : "Next"),
          ),
        ],
      ),
    );
  }
}
