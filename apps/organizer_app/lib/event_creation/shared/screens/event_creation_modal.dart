// event_creation_modal.dart - updated

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/screens/basic_details_screen.dart';
import 'package:organizer_app/event_creation/finishing_details/screen/finishing_details_screen.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_bloc.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_event.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_state.dart';
import 'package:organizer_app/event_creation/shared/screens/event_creation_navigation_bar.dart';
import 'package:organizer_app/event_creation/shared/screens/top_bar.dart';
import 'package:organizer_app/event_creation/shared/services/event_creation_service.dart';
import 'package:organizer_app/event_creation/ticket_details/screens/ticket_details_screen.dart';
import 'package:organizer_app/events_page/screens/event_list_screen.dart';
import 'package:shared/widgets/draggable_modal_layout.dart';

class EventCreationModal extends StatelessWidget {
  final String createdByUserId;

  const EventCreationModal(
    {super.key, 
    required this.createdByUserId
    });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCreationBloc(
        RepositoryProvider.of(context), 
        eventCreationService: context.read<EventCreationService>(), // Ensure the service is provided here
      )..add(InitializeEventCreation(createdByUserId)),
      child: const _EventCreationModalBody(),
    );
  }
}

class _EventCreationModalBody extends StatefulWidget {
  const _EventCreationModalBody({super.key});

  @override
  State<_EventCreationModalBody> createState() =>
      _EventCreationModalBodyState();
}

class _EventCreationModalBodyState extends State<_EventCreationModalBody> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCreationBloc, EventCreationState>(
      builder: (context, state) {
        if (state is EventCreationLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EventCreationError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Error loading event creation',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => context
                      .read<EventCreationBloc>()
                      .add(InitializeEventCreation('')),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is EventCreationReady) {
          return DraggableModalLayout(
            backgroundChild: const EventListScreen(),
            modalChild: Column(
              children: [
                TopBar(onSaveAndExit: () {
                  context.read<EventCreationBloc>().add(SaveAndExit());
                  Navigator.pop(context);
                }),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      if (state is EventCreationReady)
                        BasicDetailsScreen(eventId: state.event.eventId),
                      TicketDetailsScreen(eventId: state.event.eventId),
                      FinishingDetailsScreen(eventId: state.event.eventId),
                    ],
                  ),
                ),
                EventCreationNavigationBar(pageController: _pageController),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }
}


/*

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/basic_details/screens/basic_details_screen.dart';
import 'package:organizer_app/event_creation/basic_details/services/basic_details_service.dart';
import 'package:organizer_app/event_creation/basic_details/blocs/basic_details_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/blocs/basic_details_state.dart';
import 'package:organizer_app/event_creation/basic_details/event_cover_image/event_image_upload_service.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_bloc.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_event.dart';
import 'package:organizer_app/event_creation/shared/blocs/event_creation_state.dart';
import 'package:organizer_app/event_creation/shared/services/save_event_service.dart';
import 'package:organizer_app/event_creation/ticket_details/blocs/ticket_details_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/screens/ticket_details_screen.dart';
import 'package:organizer_app/event_creation/ticket_details/services/ticket_details_service.dart';
import 'package:shared/repositories/event_repository.dart';
import 'package:shared/repositories/ticket_repository.dart';
import '../../../event_list/event_list_screen.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventCreationBloc>(
          create: (context) => EventCreationBloc(
            saveEventService: context.read<SaveEventService>(),
            logger: Logger(),
          )..add(InitializeEventCreation(userId)),
        ),
        BlocProvider<BasicDetailsBloc>(
          create: (context) => BasicDetailsBloc(
            basicDetailsService: BasicDetailsService(
              eventRepository: context.read<EventRepository>(),
              logger: Logger(),
              imageUploadService: context.read<ImageUploadService>(),
            ),
            logger: Logger(),
            eventId: '',
          ),
        ),
        BlocProvider<TicketDetailsBloc>(
          create: (context) => TicketDetailsBloc(
            ticketDetailsService: TicketDetailsService(
              ticketRepository: context.read<TicketRepository>(),
              logger: Logger(),
            ),
            logger: Logger(),
            eventId: '',
          ),
        ),
      ],
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
        const EventListScreen(),
        AnimatedBuilder(
          animation: _opacityAnimation,
          builder: (context, child) {
            return Container(
              color: Colors.black.withOpacity(_opacityAnimation.value),
            );
          },
        ),
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
  State<EventCreationModal> createState() => _EventCreationModalState();
}

class _EventCreationModalState extends State<EventCreationModal>
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
                      _buildTopBar(context),
                      Expanded(
                        child: BlocConsumer<EventCreationBloc, EventCreationState>(
                          listener: (context, state) {
                            if (state is EventCreationError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            } else if (state is EventCreationSaved) {
                              widget.onHideModal();
                              Navigator.of(context).pop();
                            }
                          },
                          builder: (context, state) {
                            if (state is EventCreationLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (state is EventCreationLoaded) {
                              return Column(
                                children: [
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

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              final state = context.read<EventCreationBloc>().state;
              if (state is EventCreationLoaded) {
                final currentFormData = _collectCurrentFormData(context);
                context.read<EventCreationBloc>().add(SaveAndExit(
                      eventId: state.eventId,
                      step: EventStep.values[state.currentStep],
                      updatedData: currentFormData,
                    ));
              }
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
        return BasicDetailsScreen(eventId: state.eventId);
      case 2:
        return TicketDetailsScreen(eventId: state.eventId);
      default:
        return const Center(child: Text("Unknown Step"));
    }
  }

  Widget _buildBottomNavigation(BuildContext context, EventCreationLoaded state) {
    final isLastStep = state.currentStep == EventStep.values.length - 1;

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
              final currentFormData = _collectCurrentFormData(context);
              if (isLastStep) {
                context.read<EventCreationBloc>().add(PublishEvent(state.eventId));
              } else {
                context.read<EventCreationBloc>().add(NextStep(
                  step: EventStep.values[state.currentStep],
                  updatedData: currentFormData,
                ));
              }
            },
            child: Text(isLastStep ? "Publish" : "Next"),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _collectCurrentFormData(BuildContext context) {
    final currentState = context.read<EventCreationBloc>().state;
    if (currentState is EventCreationLoaded) {
      switch (currentState.currentStep) {
        case 1: // BasicDetails step
          final basicDetailsState = context.read<BasicDetailsBloc>().state;
          if (basicDetailsState is BasicDetailsValid) {
            return basicDetailsState.formData;
          }
          break;
        case 2: // TicketDetails step
          return {}; // Placeholder for TicketDetailsBloc logic
        default:
          return {};
      }
    }
    return {};
  }
}

*/