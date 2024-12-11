// finishing_details_state.dart:

import 'package:equatable/equatable.dart';
import '../models/finishing_details_model.dart';

abstract class FinishingDetailsState extends Equatable {
  const FinishingDetailsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class FinishingDetailsInitial extends FinishingDetailsState {}

/// Loading state
class FinishingDetailsLoading extends FinishingDetailsState {}

/// Loaded state
class FinishingDetailsLoaded extends FinishingDetailsState {
  final FinishingDetailsModel finishingDetails;

  const FinishingDetailsLoaded(this.finishingDetails);

  @override
  List<Object?> get props => [finishingDetails];
}

/// Saving state
class FinishingDetailsSaving extends FinishingDetailsState {}

/// Saved successfully state
class FinishingDetailsSaved extends FinishingDetailsState {}

/// Error state
class FinishingDetailsError extends FinishingDetailsState {
  final String errorMessage;

  const FinishingDetailsError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

/*

// finishing_details_state.dart

import 'package:equatable/equatable.dart';

abstract class FinishingDetailsState extends Equatable {
  const FinishingDetailsState();

  @override
  List<Object?> get props => [];
}

// Initial state
class FinishingDetailsInitial extends FinishingDetailsState {}

// Loading state
class FinishingDetailsLoading extends FinishingDetailsState {}

// Success state after saving or submitting details
class FinishingDetailsSaved extends FinishingDetailsState {
  final Map<String, dynamic> finishingData;

  const FinishingDetailsSaved(this.finishingData);

  @override
  List<Object?> get props => [finishingData];
}

// Error state with a descriptive error message
class FinishingDetailsError extends FinishingDetailsState {
  final String message;

  const FinishingDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Validation error state for incomplete or incorrect data
class FinishingDetailsValidationFailed extends FinishingDetailsState {
  final List<String> missingFields;

  const FinishingDetailsValidationFailed(this.missingFields);

  @override
  List<Object?> get props => [missingFields];
}


*/