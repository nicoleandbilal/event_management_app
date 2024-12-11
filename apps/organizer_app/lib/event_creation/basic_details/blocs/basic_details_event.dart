// basic_details_event.dart - updated

import 'package:equatable/equatable.dart';
import '../models/basic_details_model.dart';

abstract class BasicDetailsEvent extends Equatable {
  const BasicDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch basic details
class FetchBasicDetails extends BasicDetailsEvent {
  final String eventId;

  const FetchBasicDetails(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

/// Event to save basic details
class SaveBasicDetails extends BasicDetailsEvent {
  final BasicDetailsModel basicDetails;

  const SaveBasicDetails(this.basicDetails);

  @override
  List<Object?> get props => [basicDetails];
}


/*

import 'dart:io';
import 'package:equatable/equatable.dart';

/// Base class for all Basic Details events
abstract class BasicDetailsEvent extends Equatable {
  const BasicDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to update a specific field
class UpdateField extends BasicDetailsEvent {
  final String field;
  final dynamic value;

  const UpdateField({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

/// Event to submit the basic details form
class SubmitBasicDetails extends BasicDetailsEvent {
  final bool saveAndExit;

  const SubmitBasicDetails({required this.saveAndExit});

  @override
  List<Object?> get props => [saveAndExit];
}

/// Event to upload event images
class UploadEventImage extends BasicDetailsEvent {
  final File fullImage;
  final File croppedImage;

  const UploadEventImage({required this.fullImage, required this.croppedImage});

  @override
  List<Object?> get props => [fullImage, croppedImage];
}

/// Event to delete uploaded images
class DeleteEventImage extends BasicDetailsEvent {}

*/