// create_event_form_state.dart

import 'package:equatable/equatable.dart';

abstract class CreateEventFormState extends Equatable {
  const CreateEventFormState();

  @override
  List<Object> get props => [];
}

class CreateEventFormInitial extends CreateEventFormState {}

class CreateEventFormLoading extends CreateEventFormState {}

class CreateEventFormSuccess extends CreateEventFormState {}

class CreateEventFormFailure extends CreateEventFormState {
  final String error;

  const CreateEventFormFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Image Uploading state
class CreateEventFormImageUploading extends CreateEventFormState {}

// Image Uploaded state
class CreateEventFormImageUploaded extends CreateEventFormState {
  final String imageUrl;

  const CreateEventFormImageUploaded(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}
