/*

// finishing_details_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared/repositories/event_repository.dart';
import 'finishing_details_event.dart';
import 'finishing_details_state.dart';

class FinishingDetailsBloc extends Bloc<FinishingDetailsEvent, FinishingDetailsState> {
  final EventRepository eventRepository;
  final Logger _logger = Logger();

  // Temporary storage for finishing details data
  final Map<String, dynamic> finishingData = {};

  FinishingDetailsBloc({required this.eventRepository}) : super(FinishingDetailsInitial()) {
    on<UpdateFinishingField>(_onUpdateFinishingField);
    on<SubmitFinishingDetails>(_onSubmitFinishingDetails);
  }

  // Handles dynamic updates for any finishing detail field
  void _onUpdateFinishingField(UpdateFinishingField event, Emitter<FinishingDetailsState> emit) {
    finishingData[event.field] = event.value;
    _logger.d('Updated ${event.field} with value: ${event.value}');
  }

  // Validates and submits finishing details
  Future<void> _onSubmitFinishingDetails(
      SubmitFinishingDetails event, Emitter<FinishingDetailsState> emit) async {
    emit(FinishingDetailsLoading());

    // Validate fields before submitting
    final missingFields = _validateFields();
    if (missingFields.isNotEmpty) {
      emit(FinishingDetailsValidationFailed(missingFields));
      return;
    }

    // If all fields are valid, save to the repository
    try {
      await eventRepository.updateEventFinishingDetails(finishingData);
      emit(FinishingDetailsSaved(finishingData));
    } catch (e) {
      _logger.e('Failed to submit finishing details: $e');
      emit(FinishingDetailsError('Failed to save finishing details: $e'));
    }
  }

  // Validates required fields for finishing details
  List<String> _validateFields() {
    final requiredFields = [
      'privacy',
      'organizerBio',
      'contactInformation',
      'refundPolicy'
    ];
    final missingFields = <String>[];

    for (var field in requiredFields) {
      if (finishingData[field] == null || finishingData[field].toString().isEmpty) {
        missingFields.add(field);
      }
    }

    return missingFields;
  }
}

*/