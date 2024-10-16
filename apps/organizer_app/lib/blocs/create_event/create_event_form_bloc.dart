// create_event_form_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/blocs/create_event/create_event_form_event.dart';
import 'package:organizer_app/blocs/create_event/create_event_form_state.dart';
import 'package:organizer_app/repositories/create_event_repository.dart';

class CreateEventFormBloc extends Bloc<CreateEventFormEvent, CreateEventFormState> {
  final CreateEventRepository eventRepository;

  CreateEventFormBloc(this.eventRepository) : super(CreateEventFormInitial()) {
    on<SubmitCreateEventForm>(_onSubmitCreateEventForm);
  }

  Future<void> _onSubmitCreateEventForm(
      SubmitCreateEventForm event, Emitter<CreateEventFormState> emit) async {
    emit(CreateEventFormLoading());
    try {
      await eventRepository.submitEvent(event.event);
      emit(CreateEventFormSuccess()); // Success state emitted here
    } catch (error) {
      emit(CreateEventFormFailure(error.toString()));
    }
  }
}
