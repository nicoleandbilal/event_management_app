import 'package:equatable/equatable.dart';

/// Base class for all Basic Details states
abstract class BasicDetailsState extends Equatable {
  const BasicDetailsState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the Basic Details step
class BasicDetailsInitial extends BasicDetailsState {}

/// State indicating a loading operation
class BasicDetailsLoading extends BasicDetailsState {}

/// State when basic details are successfully validated
class BasicDetailsValid extends BasicDetailsState {
  final Map<String, dynamic> formData;

  const BasicDetailsValid(this.formData);

  @override
  List<Object?> get props => [formData];
}

/// State indicating that basic details have been saved and exited
class BasicDetailsSaved extends BasicDetailsState {}

/// Error state with an error message
class BasicDetailsError extends BasicDetailsState {
  final String message;

  const BasicDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State indicating image upload is in progress
class EventImageUploading extends BasicDetailsState {}

/// State when images are successfully uploaded
class EventImageUploadSuccess extends BasicDetailsState {
  final String? fullImageUrl;
  final String? croppedImageUrl;

  const EventImageUploadSuccess({
    this.fullImageUrl,
    this.croppedImageUrl,
  });

  @override
  List<Object?> get props => [fullImageUrl, croppedImageUrl];
}

/// State indicating image deletion is in progress
class EventImageDeleting extends BasicDetailsState {}

/// State when images are successfully deleted
class EventImageDeleteSuccess extends BasicDetailsState {}