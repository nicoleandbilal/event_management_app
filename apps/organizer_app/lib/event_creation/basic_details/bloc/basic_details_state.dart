import 'package:equatable/equatable.dart';

abstract class BasicDetailsState extends Equatable {
  const BasicDetailsState();

  @override
  List<Object?> get props => [];
}

// Initial state of the basic details form
class BasicDetailsInitial extends BasicDetailsState {}

// State indicating a loading process
class BasicDetailsLoading extends BasicDetailsState {}

// State when form data is validated and ready for submission
class BasicDetailsValid extends BasicDetailsState {
  final Map<String, dynamic> formData;

  const BasicDetailsValid(this.formData);

  @override
  List<Object?> get props => [formData];
}

// State when basic details are successfully saved and exited
class BasicDetailsSaved extends BasicDetailsState {}

// State for errors in validation or processing
class BasicDetailsError extends BasicDetailsState {
  final String message;

  const BasicDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// State for tracking missing fields in the form
class BasicDetailsValidationFailed extends BasicDetailsState {
  final List<String> missingFields;

  const BasicDetailsValidationFailed(this.missingFields);

  @override
  List<Object?> get props => [missingFields];
}

// State indicating image upload is in progress
class EventImageUploading extends BasicDetailsState {}

// State for successful image upload
class EventImageUploadSuccess extends BasicDetailsState {
  final String? fullImageUrl;
  final String? croppedImageUrl;

  const EventImageUploadSuccess(this.fullImageUrl, this.croppedImageUrl);

  @override
  List<Object?> get props => [fullImageUrl, croppedImageUrl];
}

// State indicating image deletion is in progress
class EventImageDeleting extends BasicDetailsState {}

// State for successful image deletion
class EventImageDeleteSuccess extends BasicDetailsState {}
