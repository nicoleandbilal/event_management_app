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

import '../event_list/event_list_screen.dart';

class EventCreationScreen extends StatelessWidget {
  final String userId;
  final String brandId;

  const EventCreationScreen({
    super.key,
    required this.userId,
    required this.brandId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCreationBloc(
        eventRepository: context.read<EventRepository>(),
        ticketRepository: context.read<TicketRepository>(),
        basicDetailsBloc: context.read<BasicDetailsBloc>(),
        ticketDetailsBloc: context.read<TicketDetailsBloc>(),
      )..add(InitializeEventCreation(userId)),
      child: _EventCreationView(),
    );
  }
}

class _EventCreationView extends StatefulWidget {
  @override
  __EventCreationViewState createState() => __EventCreationViewState();
}

class __EventCreationViewState extends State<_EventCreationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void showModal() {
    _animationController.forward();
  }

  void hideModal() {
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Screen
        const EventListScreen(),

        // Animated Opacity Layer
        AnimatedBuilder(
          animation: _opacityAnimation,
          builder: (context, child) {
            return Container(
              color: Colors.black.withOpacity(_opacityAnimation.value),
            );
          },
        ),

        // Draggable Modal
        EventCreationModal(
          onShowModal: showModal,
          onHideModal: hideModal,
        ),
      ],
    );
  }
}

class EventCreationModal extends StatefulWidget {
  final VoidCallback onShowModal;
  final VoidCallback onHideModal;

  const EventCreationModal({
    super.key,
    required this.onShowModal,
    required this.onHideModal,
  });

  @override
  EventCreationModalState createState() => EventCreationModalState();
}

class EventCreationModalState extends State<EventCreationModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onShowModal();
      _animationController.forward();
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final dragDelta = details.primaryDelta ?? 0.0;
    _animationController.value -= dragDelta / MediaQuery.of(context).size.height;
  }

void _onDragEnd(DragEndDetails details) {
  if (_animationController.value < 0.5) {
    widget.onHideModal();
    _animationController.reverse().then((_) {
      // Navigate back or clean up state after modal is fully dismissed
      Navigator.of(context).pop();
    });
  } else {
    _animationController.forward();
  }
}


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: FractionalTranslation(
            translation: Offset(0.0, _offsetAnimation.value),
            child: GestureDetector(
              onVerticalDragUpdate: _onDragUpdate,
              onVerticalDragEnd: _onDragEnd,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Expanded(
                        child: BlocConsumer<EventCreationBloc, EventCreationState>(
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
                              return Column(
                                children: [
                                  _buildTopBar(context),
                                  Expanded(
                                    child: _buildContent(context, state),
                                  ),
                                  _buildBottomNavigation(context, state),
                                ],
                              );
                            }
                            return const Center(child: Text("Initializing..."));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
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
              Navigator.pop(context); // Dismiss the modal
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
                context.read<EventCreationBloc>().add(PublishEvent(
                  Event(
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
                  ),
                ));
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