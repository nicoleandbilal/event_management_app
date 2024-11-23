// basic_details_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/event_cover_image/event_image_upload_service.dart';
import 'package:shared/repositories/event_repository.dart';
import 'basic_details_event.dart';
import 'basic_details_state.dart';
import 'package:logger/logger.dart';

class BasicDetailsBloc extends Bloc<BasicDetailsEvent, BasicDetailsState> {
  final EventRepository eventRepository;
  final ImageUploadService imageUploadService;
  final Logger _logger = Logger();
  String eventId;

  // Field variables for temporary storage
  final Map<String, dynamic> formData = {};
  String? fullImageUrl;
  String? croppedImageUrl;

  BasicDetailsBloc({
    required this.eventRepository,
    required this.imageUploadService,
    required this.eventId,
  }) : super(BasicDetailsInitial()) {
    on<UpdateField>(_onUpdateField);
    on<SubmitBasicDetails>(_onSubmitBasicDetails);
    on<UploadEventImage>(_onUploadEventImage);
    on<DeleteEventImage>(_onDeleteEventImage);
  }

  // Handles updates 
  void _onUpdateField(UpdateField event, Emitter<BasicDetailsState> emit) {
    formData[event.field] = event.value;
    _logger.d('Field "${event.field}" updated with value: ${event.value}');
    // Do not emit any state. Only update internal state (formData).
  }

  // Validate and submit form data
  Future<void> _onSubmitBasicDetails(
      SubmitBasicDetails event, Emitter<BasicDetailsState> emit) async {
    final missingFields = _validateFields();
    if (missingFields.isNotEmpty) {
      emit(BasicDetailsValidationFailed(missingFields));
      return;
    }

    try {
      emit(BasicDetailsLoading());
      await eventRepository.updateDraftEvent(eventId, formData);
      emit(BasicDetailsValid(formData));
    } catch (error) {
      _logger.e('Error saving basic details: $error');
      emit(BasicDetailsError("Failed to save details: $error"));
    }
  }

  // Image upload event handler
  Future<void> _onUploadEventImage(UploadEventImage event, Emitter<BasicDetailsState> emit) async {
    emit(EventImageUploading());
    try {
      final imageUrls = await imageUploadService.uploadFullAndCroppedImages(
        event.fullImage,
        event.croppedImage,
        eventId,
      );
      fullImageUrl = imageUrls['fullImageUrl'];
      croppedImageUrl = imageUrls['croppedImageUrl'];
      emit(EventImageUploadSuccess(fullImageUrl, croppedImageUrl));
    } catch (error) {
      _logger.e('Image upload failed: $error');
      emit(BasicDetailsError("Image upload failed: $error"));
    }
  }

  // Image delete event handler
  Future<void> _onDeleteEventImage(DeleteEventImage event, Emitter<BasicDetailsState> emit) async {
    emit(EventImageDeleting());
    try {
      await imageUploadService.deleteEventCoverImages(eventId);
      fullImageUrl = null;
      croppedImageUrl = null;
      emit(EventImageDeleteSuccess());
    } catch (error) {
      _logger.e('Image deletion failed: $error');
      emit(BasicDetailsError("Image deletion failed: $error"));
    }
  }

  // Validate required fields
  List<String> _validateFields() {
    final requiredFields = [
      'eventName', 
      'description', 
      'category', 
      'startDateTime', 
      'endDateTime'];
    final missingFields = <String>[];

    for (var field in requiredFields) {
      if (formData[field] == null || formData[field].toString().isEmpty) {
        missingFields.add(field);
      }
    }

    if (formData['startDateTime'] != null &&
        formData['endDateTime'] != null &&
        formData['endDateTime'].isBefore(formData['startDateTime'])) {
      missingFields.add('End Date must be after Start Date');
    }

    return missingFields;
  }
}
