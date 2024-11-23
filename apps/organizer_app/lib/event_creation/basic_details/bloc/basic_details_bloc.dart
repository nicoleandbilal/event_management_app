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
  final String eventId;

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

  /// Handles field updates triggered by `UpdateField` events.
  void _onUpdateField(UpdateField event, Emitter<BasicDetailsState> emit) {
    formData[event.field] = event.value;
    _logger.d('Field "${event.field}" updated with value: ${event.value}');
  }

  /// Handles form submission and validation, triggered by `SubmitBasicDetails` events.
  Future<void> _onSubmitBasicDetails(
      SubmitBasicDetails event, Emitter<BasicDetailsState> emit) async {
    // Proceed to save the draft
    try {
      emit(BasicDetailsLoading());
      _logger.i("Submitting form data: $formData");

      // Save form data to Firestore
      await eventRepository.updateDraftEvent(eventId, formData);

      emit(BasicDetailsValid(formData));

      if (event.saveAndExit) {
        emit(BasicDetailsSaved()); // Indicate successful save and exit
        _logger.i("Form data saved successfully for event ID: $eventId");
      }
    } catch (error) {
      _logger.e('Error saving details: $error');
      emit(BasicDetailsError("Failed to save details. Please try again."));
    }
  }

  /// Handles event image uploads, triggered by `UploadEventImage` events.
  Future<void> _onUploadEventImage(
      UploadEventImage event, Emitter<BasicDetailsState> emit) async {
    emit(EventImageUploading());
    try {
      final imageUrls = await imageUploadService.uploadFullAndCroppedImages(
        event.fullImage,
        event.croppedImage,
        eventId,
      );

      formData["fullImageUrl"] = imageUrls['fullImageUrl'];
      formData["croppedImageUrl"] = imageUrls['croppedImageUrl'];

      emit(EventImageUploadSuccess(
        formData["fullImageUrl"],
        formData["croppedImageUrl"],
      ));
      _logger.i("Image uploaded successfully for event ID: $eventId");
    } catch (error) {
      _logger.e('Image upload failed: $error');
      emit(BasicDetailsError("Image upload failed. Please try again."));
    }
  }

  /// Handles event image deletions, triggered by `DeleteEventImage` events.
  Future<void> _onDeleteEventImage(
      DeleteEventImage event, Emitter<BasicDetailsState> emit) async {
    emit(EventImageDeleting());
    try {
      await imageUploadService.deleteEventCoverImages(eventId);
      formData.remove("fullImageUrl");
      formData.remove("croppedImageUrl");

      emit(EventImageDeleteSuccess());
      _logger.i("Image deleted successfully for event ID: $eventId");
    } catch (error) {
      _logger.e('Image deletion failed: $error');
      emit(BasicDetailsError("Image deletion failed. Please try again."));
    }
  }
}
