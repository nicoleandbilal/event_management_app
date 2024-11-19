/*

// finishing_details_event.dart

import 'package:equatable/equatable.dart';

abstract class FinishingDetailsEvent extends Equatable {
  const FinishingDetailsEvent();

  @override
  List<Object?> get props => [];
}

// Update event for all finishing details fields
class UpdateFinishingField extends FinishingDetailsEvent {
  final String field;
  final dynamic value;

  const UpdateFinishingField({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

// Finalize and submit finishing details
class SubmitFinishingDetails extends FinishingDetailsEvent {}

*/
