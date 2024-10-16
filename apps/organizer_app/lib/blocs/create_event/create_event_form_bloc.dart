import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:organizer_app/models/create_event_model.dart';
import 'package:organizer_app/repositories/create_event_repository.dart';

// CreateEventFormEvent: represents events like submitting form, changing inputs
abstract class CreateEventFormEvent extends Equatable {
  const CreateEventFormEvent();
}

class SubmitCreateEventForm extends CreateEventFormEvent {
  final CreateEvent event;

  const SubmitCreateEventForm(this.event);

  @override
  List<Object?> get props => [event];
}

class UpdateCreateEventName extends CreateEventFormEvent {
  final String eventName;
  
  const UpdateCreateEventName(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

// Add more events as needed (e.g., UpdateStartDate, UpdateEndDate, etc.)

// CreateEventFormState: represents states like loading, success, failure
abstract class CreateEventFormState extends Equatable {
  const CreateEventFormState();
}

class CreateEventFormInitial extends CreateEventFormState {
  @override
  List<Object> get props => [];
}

class CreateEventFormLoading extends CreateEventFormState {
  @override
  List<Object> get props => [];
}

class CreateEventFormSuccess extends CreateEventFormState {
  @override
  List<Object> get props => [];
}

class CreateEventFormFailure extends CreateEventFormState {
  final String error;

  const CreateEventFormFailure(this.error);

  @override
  List<Object> get props => [error];
}

// CreateEventFormBloc: handles business logic and emits state changes
class CreateEventFormBloc extends Bloc<CreateEventFormEvent, CreateEventFormState> {
  final CreateEventRepository eventRepository;

  CreateEventFormBloc(this.eventRepository) : super(CreateEventFormInitial()) {
    on<SubmitCreateEventForm>(_onSubmitCreateEventForm);
  }

  Future<void> _onSubmitCreateEventForm(SubmitCreateEventForm event, Emitter<CreateEventFormState> emit) async {
    emit(CreateEventFormLoading());
    try {
      await eventRepository.submitEvent(event.event);  // Handles API/microservice call
      emit(CreateEventFormSuccess());
    } catch (error) {
      emit(CreateEventFormFailure(error.toString()));
    }
  }
}
