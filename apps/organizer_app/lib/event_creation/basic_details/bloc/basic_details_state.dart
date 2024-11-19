// basic_details_state.dart

import 'package:equatable/equatable.dart';

abstract class BasicDetailsState extends Equatable {
  const BasicDetailsState();

  @override
  List<Object?> get props => [];
}

// Initial state for Basic Details form
class BasicDetailsInitial extends BasicDetailsState {}

// State for loading processes (e.g., image upload, form submission)
class BasicDetailsLoading extends BasicDetailsState {}

// State when form data is successfully validated and ready to submit
class BasicDetailsValid extends BasicDetailsState {
  final Map<String, dynamic> formData;

  const BasicDetailsValid(this.formData);

  @override
  List<Object?> get props => [formData];
}

// Error state for validation or processing failures
class BasicDetailsError extends BasicDetailsState {
  final String message;

  const BasicDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// State for missing fields or invalid input
class BasicDetailsValidationFailed extends BasicDetailsState {
  final List<String> missingFields;

  const BasicDetailsValidationFailed(this.missingFields);

  @override
  List<Object?> get props => [missingFields];
}

// State for tracking image upload in progress
class EventImageUploading extends BasicDetailsState {}

// State for successful image upload
class EventImageUploadSuccess extends BasicDetailsState {
  final String? fullImageUrl;
  final String? croppedImageUrl;

  const EventImageUploadSuccess(this.fullImageUrl, this.croppedImageUrl);

  @override
  List<Object?> get props => [fullImageUrl, croppedImageUrl];
}

// State for image deletion in progress
class EventImageDeleting extends BasicDetailsState {}

// State for successful image deletion
class EventImageDeleteSuccess extends BasicDetailsState {}
