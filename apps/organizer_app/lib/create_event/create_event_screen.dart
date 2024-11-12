// create_event_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_bloc.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_event.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_state.dart';
import 'package:organizer_app/create_event/event_details/bloc/event_details_bloc.dart';
import 'package:organizer_app/create_event/event_details/bloc/event_details_event.dart';
import 'package:organizer_app/create_event/event_details/bloc/event_details_state.dart';
import 'package:organizer_app/create_event/ticketing/bloc/ticket_details_bloc.dart';
import 'package:organizer_app/create_event/event_details/create_event_details_form.dart';
import 'package:organizer_app/create_event/ticketing/bloc/ticket_details_event.dart';
import 'package:organizer_app/create_event/ticketing/create_ticketing_form.dart';
import 'package:organizer_app/create_event/ticketing/add_ticket_dialog.dart';
import 'package:shared/authentication/auth/auth_service.dart';
import 'package:shared/widgets/custom_padding_button.dart';

class CreateEventScreen extends StatefulWidget {
  final String brandId;

  const CreateEventScreen({super.key, required this.brandId});

  @override
  CreateEventScreenState createState() => CreateEventScreenState();
}

class CreateEventScreenState extends State<CreateEventScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? _eventId;

  @override
  void initState() {
    super.initState();
    _initializeFormDraftEvent();
  }

  // Initializes a new draft event by triggering EventDetailsBloc
  void _initializeFormDraftEvent() {
    final createdByUserId = context.read<AuthService>().getCurrentUserId();
    if (createdByUserId != null) {
      context.read<EventDetailsBloc>().add(InitializeDraftEvent(
        brandId: widget.brandId,
        createdByUserId: createdByUserId,
      ));
    }
  }

  // Navigates to the next page if the current page is valid
  void _navigateToNextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage += 1);
    }
  }

  // Finalizes the form by submitting it through CreateEventFormBloc
  void _submitForm() {
    context.read<CreateEventFormBloc>().add(CreateEventFormSubmitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EventDetailsBloc, EventDetailsState>(
          listener: (context, state) {
            if (state is EventDraftInitialized) {
              setState(() => _eventId = state.eventId);
            } else if (state is EventDetailsFailure) {
              _showErrorDialog(state.error);
            }
          },
        ),
        BlocListener<CreateEventFormBloc, CreateEventFormState>(
          listener: (context, state) {
            if (state is CreateEventFormSubmissionFailure) {
              _showErrorDialog(state.error);
            } else if (state is CreateEventFormSubmissionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event created successfully!')),
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Event'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _currentPage == 0
                ? Navigator.of(context).pop
                : () => Navigator.pop(context),
          ),
        ),
        body: _eventId != null
            ? PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CreateEventDetailsForm(
                      brandId: widget.brandId,
                      eventId: _eventId!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CreateTicketForm(
                      eventId: _eventId!,
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomPaddingButton(
                  onPressed: () {
                    _saveDraft(); // Save current form page data
                    Navigator.pop(context); // Return to previous screen
                  },
                  label: 'Save',
                  backgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomPaddingButton(
                  onPressed: () {
                    _saveDraft(); // Save current form page data
                    if (_currentPage < 1) {
                      _navigateToNextPage(); // Go to the next page
                    } else {
                      _submitForm(); // Submit the form on the last page
                    }
                  },
                  label: _currentPage == 1 ? 'Submit' : 'Next',
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Saves draft data of the current page
  void _saveDraft() {
    if (_currentPage == 0) {
      final formData = CreateEventDetailsForm.collectFormData();
      context.read<EventDetailsBloc>().add(SaveEventDetailsEvent(formData));
    } else if (_currentPage == 1) {
      // Collect ticket data directly from AddTicketDialog
      final ticketData = AddTicketDialog(eventId: _eventId!).createState().getTicketData();
      context.read<TicketDetailsBloc>().add(SaveTicketDetailsEvent(ticket: ticketData));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft saved successfully')),
    );
  }

  // Displays an error dialog with a given message
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
