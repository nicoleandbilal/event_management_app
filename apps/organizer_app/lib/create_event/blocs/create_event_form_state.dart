import 'package:equatable/equatable.dart';

abstract class CreateEventFormState extends Equatable {
  const CreateEventFormState();

  @override
  List<Object?> get props => [];
}

class CreateEventFormInitial extends CreateEventFormState {}

class CreateEventFormLoading extends CreateEventFormState {}

class CreateEventFormSuccess extends CreateEventFormState {}

class CreateEventFormFailure extends CreateEventFormState {
  final String error;

  const CreateEventFormFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class CreateEventFormImageUploading extends CreateEventFormState {}

class CreateEventFormImageUrlsUpdated extends CreateEventFormState {
  final String? fullImageUrl;
  final String? croppedImageUrl;

  const CreateEventFormImageUrlsUpdated({this.fullImageUrl, this.croppedImageUrl});

  @override
  List<Object?> get props => [fullImageUrl, croppedImageUrl];
}
