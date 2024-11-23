// basic_details_event.dart

import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class BasicDetailsEvent extends Equatable {
  const BasicDetailsEvent();

  @override
  List<Object?> get props => [];
}

// Event to update a single field in the basic details form
class UpdateField extends BasicDetailsEvent {
  final String field;
  final dynamic value;

  const UpdateField({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

// Event to submit and validate the form
class SubmitBasicDetails extends BasicDetailsEvent {
  final bool saveAndExit;

  const SubmitBasicDetails({required this.saveAndExit});

  @override
  List<Object?> get props => [saveAndExit];
}


// Event to upload an image (both full and cropped versions)
class UploadEventImage extends BasicDetailsEvent {
  final File fullImage;
  final File croppedImage;

  const UploadEventImage({required this.fullImage, required this.croppedImage});

  @override
  List<Object?> get props => [fullImage, croppedImage];
}

// Event to delete uploaded images
class DeleteEventImage extends BasicDetailsEvent {}
