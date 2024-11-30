import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/basic_details/basic_details_service.dart';
import 'basic_details_event.dart';
import 'basic_details_state.dart';

/// Bloc for managing Basic Details logic and state
class BasicDetailsBloc extends Bloc<BasicDetailsEvent, BasicDetailsState> {
  final BasicDetailsService basicDetailsService;
  final Logger logger;
  final String eventId;

  /// In-memory form data storage
  final Map<String, dynamic> _formData = {};

  /// Map to store debounce timers for fields
  final Map<String, Timer> _debounceTimers = {};

  BasicDetailsBloc({
    required this.basicDetailsService,
    required this.logger,
    required this.eventId,
  }) : super(BasicDetailsInitial()) {
    on<UpdateField>(_onUpdateField);
    on<SubmitBasicDetails>(_onSubmitBasicDetails);
    on<UploadEventImage>(_onUploadEventImage);
    on<DeleteEventImage>(_onDeleteEventImage);
  }

  /// Updates form data for a given field with a debounce mechanism
  Future<void> _onUpdateField(UpdateField event, Emitter<BasicDetailsState> emit) async {
    if (_debounceTimers[event.field] != null) {
      _debounceTimers[event.field]!.cancel();
    }

    // Use a debounce to reduce state updates
    _debounceTimers[event.field] = Timer(const Duration(milliseconds: 300), () {
      _formData[event.field] = event.value;
      logger.d('Field "${event.field}" updated with value: ${event.value}');
      if (!emit.isDone) {
        emit(BasicDetailsValid(Map<String, dynamic>.from(_formData)));
      }
    });
  }

  /// Handles form submission with validation and saving
  Future<void> _onSubmitBasicDetails(
      SubmitBasicDetails event, Emitter<BasicDetailsState> emit) async {
    emit(BasicDetailsLoading());

    try {
      // Validation: Ensure all required fields are present
      final requiredFields = ['eventName', 'startDateTime', 'endDateTime', 'venue'];
      final missingFields = requiredFields
          .where((field) =>
              _formData[field] == null || _formData[field].toString().isEmpty)
          .toList();

      if (missingFields.isNotEmpty) {
        final errorMessage = "Missing Fields: ${missingFields.join(', ')}";
        logger.e(errorMessage);
        if (!emit.isDone) {
          emit(BasicDetailsError(errorMessage));
        }
        return;
      }

      await basicDetailsService.saveBasicDetails(eventId, Map<String, dynamic>.from(_formData));

      if (!emit.isDone) {
        if (event.saveAndExit) {
          emit(BasicDetailsSaved());
          logger.i('Basic details saved and exited for event ID: $eventId.');
        } else {
          emit(BasicDetailsValid(Map<String, dynamic>.from(_formData)));
          logger.i('Basic details successfully submitted for event ID: $eventId.');
        }
      }
    } catch (e) {
      logger.e('Failed to save basic details for event ID: $eventId: $e');
      if (!emit.isDone) {
        emit(const BasicDetailsError('Failed to save basic details. Please try again.'));
      }
    }
  }

  /// Handles image uploads and updates form data
  Future<void> _onUploadEventImage(
      UploadEventImage event, Emitter<BasicDetailsState> emit) async {
    emit(EventImageUploading());

    try {
      logger.i('Uploading images for event ID: $eventId');
      final imageUrls = await basicDetailsService.uploadEventImages(
        eventId: eventId,
        fullImage: event.fullImage,
        croppedImage: event.croppedImage,
      );

      _formData['fullImageUrl'] = imageUrls['fullImageUrl'];
      _formData['croppedImageUrl'] = imageUrls['croppedImageUrl'];

      if (!emit.isDone) {
        emit(EventImageUploadSuccess(
          fullImageUrl: imageUrls['fullImageUrl'],
          croppedImageUrl: imageUrls['croppedImageUrl'],
        ));
      }
      logger.i('Images uploaded successfully for event ID: $eventId.');
    } catch (e) {
      logger.e('Failed to upload images for event ID: $eventId: $e');
      if (!emit.isDone) {
        emit(const BasicDetailsError('Failed to upload images. Please try again.'));
      }
    }
  }

  /// Handles image deletions and updates form data
  Future<void> _onDeleteEventImage(
      DeleteEventImage event, Emitter<BasicDetailsState> emit) async {
    emit(EventImageDeleting());

    try {
      logger.i('Deleting images for event ID: $eventId');
      await basicDetailsService.deleteEventImages(eventId);

      _formData.remove('fullImageUrl');
      _formData.remove('croppedImageUrl');

      if (!emit.isDone) {
        emit(EventImageDeleteSuccess());
      }
      logger.i('Images deleted successfully for event ID: $eventId.');
    } catch (e) {
      logger.e('Failed to delete images for event ID: $eventId: $e');
      if (!emit.isDone) {
        emit(const BasicDetailsError('Failed to delete images. Please try again.'));
      }
    }
  }

  @override
  Future<void> close() {
    // Cancel all timers on bloc disposal
    for (var timer in _debounceTimers.values) {
      timer.cancel();
    }
    return super.close();
  }
}