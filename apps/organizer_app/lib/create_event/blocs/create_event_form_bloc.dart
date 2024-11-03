// create_event_form_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_event/event_image_upload_service.dart';
import 'package:shared/repositories/event_repository.dart';
import 'create_event_form_event.dart';
import 'create_event_form_state.dart';

class CreateEventFormBloc extends Bloc<CreateEventFormEvent, CreateEventFormState> {
  final EventRepository eventRepository;
  final ImageUploadService imageUploadService;

  CreateEventFormBloc(
    this.eventRepository, 
    this.imageUploadService
    ) : super(CreateEventFormInitial()) {
    on<CreateDraftEvent>(_onCreateDraftEvent);
    on<SubmitCreateEventForm>(_onSubmitCreateEventForm);
    on<UpdateImageUrls>(_onUpdateImageUrls);
    on<DeleteImageUrls>(_onDeleteImageUrls);
  }

  Future<void> _onCreateDraftEvent(
    CreateDraftEvent event, 
    Emitter<CreateEventFormState> emit,
  ) async {
    try {
      final eventId = await eventRepository.createDraftEvent(event.event);
      emit(CreateEventFormDraftCreated(eventId: eventId));
    } catch (error) {
      emit(CreateEventFormFailure(error.toString()));
    }
  }

  Future<void> _onSubmitCreateEventForm(
    SubmitCreateEventForm event, 
    Emitter<CreateEventFormState> emit
  ) async {
    emit(CreateEventFormLoading());
    try {
      await eventRepository.submitEvent(event.event);
      emit(CreateEventFormSuccess());
    } catch (error) {
      emit(CreateEventFormFailure(error.toString()));
    }
  }

  Future<void> _onUpdateImageUrls(
    UpdateImageUrls event, Emitter<CreateEventFormState> emit
  ) async {
    emit(CreateEventFormImageUploading());
    emit(CreateEventFormImageUrlsUpdated(
      fullImageUrl: event.fullImageUrl,
      croppedImageUrl: event.croppedImageUrl,
    ));
  }

  void _onDeleteImageUrls(DeleteImageUrls event, Emitter<CreateEventFormState> emit) {
    emit(const CreateEventFormImageUrlsUpdated());
  }
}
