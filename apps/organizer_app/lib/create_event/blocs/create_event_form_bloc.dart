// create_event_form_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_event.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_state.dart';
import 'package:organizer_app/create_event/repositories/create_event_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CreateEventFormBloc extends Bloc<CreateEventFormEvent, CreateEventFormState> {
  final CreateEventRepository eventRepository;
  final FirebaseStorage firebaseStorage; // Firebase Storage added

  CreateEventFormBloc(this.eventRepository, this.firebaseStorage) : super(CreateEventFormInitial()) {
    on<SubmitCreateEventForm>(_onSubmitCreateEventForm);
    on<UpdateCreateEventImageUrl>(_onUpdateCreateEventImageUrl);
    on<DeleteCreateEventImage>(_onDeleteCreateEventImage);  // Add the handler for the new delete event
  }

  // Handle image upload
  Future<void> _onUpdateCreateEventImageUrl(
    UpdateCreateEventImageUrl event, 
    Emitter<CreateEventFormState> emit
  ) async {
    emit(CreateEventFormImageUploading());
    try {
      // Upload the image to Firebase Storage
      final fileName = DateTime.now().toString();
      final ref = firebaseStorage.ref().child('event_images/$fileName');
      await ref.putFile(File(event.imageUrl));
      final imageUrl = await ref.getDownloadURL();

      emit(CreateEventFormImageUploaded(imageUrl));  // Emit success state with URL
    } catch (error) {
      emit(CreateEventFormFailure(error.toString()));  // Emit failure state
    }
  }

  // Handle image deletion
  Future<void> _onDeleteCreateEventImage(
    DeleteCreateEventImage event, 
    Emitter<CreateEventFormState> emit
  ) async {
    emit(CreateEventFormInitial()); // Reset the form state to initial, allowing new image uploads
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
