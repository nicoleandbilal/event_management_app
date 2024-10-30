import 'package:equatable/equatable.dart';

abstract class CreateBrandFormState extends Equatable {
  const CreateBrandFormState();

  @override
  List<Object> get props => [];
}

class CreateBrandFormInitial extends CreateBrandFormState {}

class CreateBrandFormLoading extends CreateBrandFormState {}

class CreateBrandFormSuccess extends CreateBrandFormState {}

class CreateBrandFormFailure extends CreateBrandFormState {
  final String error;

  const CreateBrandFormFailure(this.error);

  @override
  List<Object> get props => [error];
}

class CreateBrandFormImageUploading extends CreateBrandFormState {}

class CreateBrandFormImageUrlsUpdated extends CreateBrandFormState {
  final String fullImageUrl;
  final String croppedImageUrl;

  const CreateBrandFormImageUrlsUpdated({
    required this.fullImageUrl,
    required this.croppedImageUrl,
  });

  @override
  List<Object> get props => [fullImageUrl, croppedImageUrl];
}

// New State for Image Upload Failure
class CreateBrandFormImageUploadFailed extends CreateBrandFormState {
  final String errorMessage;

  const CreateBrandFormImageUploadFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
