// create_event_form_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_event/event_details/bloc/event_details_bloc.dart';
import 'package:organizer_app/create_event/event_details/bloc/event_details_state.dart';
import 'package:organizer_app/create_event/ticketing/bloc/ticket_details_bloc.dart';
import 'package:organizer_app/create_event/ticketing/bloc/ticket_details_state.dart';
import 'create_event_form_event.dart';
import 'create_event_form_state.dart';

class CreateEventFormBloc extends Bloc<CreateEventFormEvent, CreateEventFormState> {
  final EventDetailsBloc eventDetailsBloc;
  final TicketDetailsBloc ticketDetailsBloc;
  int currentPage = 0;

  CreateEventFormBloc({
    required this.eventDetailsBloc,
    required this.ticketDetailsBloc,
  }) : super(CreateEventFormNavigationInitial()) {
    on<CreateEventFormNextPageEvent>(_onNextPageEvent);
    on<CreateEventFormSubmitEvent>(_onSubmitFormEvent);
  }

  // Handles navigation and verifies prerequisites before proceeding
  Future<void> _onNextPageEvent(
      CreateEventFormNextPageEvent event, Emitter<CreateEventFormState> emit) async {
    if (currentPage == 0) {
      // Ensure event details are saved before proceeding
      if (eventDetailsBloc.state is EventDetailsSaved) {
        currentPage++;
        emit(CreateEventFormNavigateToPage(currentPage));
      } else {
        emit(const CreateEventFormNavigationError("Complete event details before proceeding."));
      }
    } else if (currentPage == 1) {
      // Ensure ticket details are saved before form submission
      if (ticketDetailsBloc.state is TicketDetailsSaved) {
        add(CreateEventFormSubmitEvent());
      } else {
        emit(const CreateEventFormNavigationError("Complete ticket details before submitting."));
      }
    }
  }

  // Manages the form submission process
  Future<void> _onSubmitFormEvent(
      CreateEventFormSubmitEvent event, Emitter<CreateEventFormState> emit) async {
    try {
      // Trigger form submission logic (add actual submission code here)
      emit(CreateEventFormSubmissionSuccess());
    } catch (e) {
      emit(CreateEventFormSubmissionFailure('Failed to submit event: $e'));
    }
  }
}
