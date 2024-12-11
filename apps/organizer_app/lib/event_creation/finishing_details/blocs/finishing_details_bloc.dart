// finishing_details_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../services/finishing_details_service.dart';
import 'finishing_details_event.dart';
import 'finishing_details_state.dart';

class FinishingDetailsBloc extends Bloc<FinishingDetailsEvent, FinishingDetailsState> {
  final FinishingDetailsService _service;
  final Logger _logger;

  FinishingDetailsBloc({
    required FinishingDetailsService service,
    required Logger logger,
  })  : _service = service,
        _logger = logger,
        super(FinishingDetailsInitial()) {
    on<FetchFinishingDetails>(_onFetchFinishingDetails);
    on<SaveFinishingDetails>(_onSaveFinishingDetails);
  }

  Future<void> _onFetchFinishingDetails(
      FetchFinishingDetails event, Emitter<FinishingDetailsState> emit) async {
    emit(FinishingDetailsLoading());
    try {
      final finishingDetails = await _service.loadFinishingDetails(event.eventId);
      if (finishingDetails != null) {
        emit(FinishingDetailsLoaded(finishingDetails));
      } else {
        emit(const FinishingDetailsError("Finishing details not found."));
      }
    } catch (e) {
      _logger.e("Failed to fetch finishing details for event ID: ${event.eventId}. Error: $e");
      emit(const FinishingDetailsError("Failed to load finishing details. Please try again."));
    }
  }

  Future<void> _onSaveFinishingDetails(
      SaveFinishingDetails event, Emitter<FinishingDetailsState> emit) async {
    emit(FinishingDetailsSaving());
    try {
      final existingEvent = await _service.loadEvent(event.finishingDetails.eventId);
      if (existingEvent == null) {
        emit(const FinishingDetailsError("Existing event not found for saving."));
        return;
      }

      await _service.saveFinishingDetails(event.finishingDetails, existingEvent);
      emit(FinishingDetailsSaved());
    } catch (e) {
      _logger.e("Failed to save finishing details for event ID: ${event.finishingDetails.eventId}. Error: $e");
      emit(const FinishingDetailsError("Failed to save finishing details. Please try again."));
    }
  }
}

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