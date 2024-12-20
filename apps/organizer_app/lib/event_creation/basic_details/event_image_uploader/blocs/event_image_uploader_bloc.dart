// event_image_uploader_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/blocs/event_image_uploader_event.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/blocs/event_image_uploader_state.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/services/event_image_uploader_service.dart';

class ImageUploaderBloc extends Bloc<ImageUploaderEvent, ImageUploaderState> {
  final ImageUploaderService imageUploaderService;
  final Logger _logger = Logger();
  String eventId;

  // Field variables for temporary storage
  final Map<String, dynamic> formData = {};
  String? fullImageUrl;
  String? croppedImageUrl;

  ImageUploaderBloc({
    required this.imageUploaderService,
    required this.eventId,
  })  : super(ImageUploaderInitial()) {
    on<UploadEventImage>(_onUploadEventImage);
    on<DeleteEventImage>(_onDeleteEventImage);
  }

  Future<void> _onUploadEventImage(
      UploadEventImage event, 
      Emitter<ImageUploaderState> emit) async {
    emit(EventImageUploading());
    try {
      final imageUrls = await imageUploaderService.uploadFullAndCroppedImages(
        event.fullImage,
        event.croppedImage,
        eventId,
      );
      fullImageUrl = imageUrls['fullImageUrl'];
      croppedImageUrl = imageUrls['croppedImageUrl'];
      emit(EventImageUploadSuccess(fullImageUrl, croppedImageUrl));
    } catch (error) {
      _logger.e('Image upload failed: $error');
      emit(ImageUploaderError("Image upload failed: $error"));
    }
  }

  /// Handles image deletions and updates form data
  // Image delete event handler
  Future<void> _onDeleteEventImage(DeleteEventImage event, Emitter<ImageUploaderState> emit) async {
    emit(EventImageDeleting());
    try {
      await imageUploaderService.deleteEventCoverImages(eventId);
      fullImageUrl = null;
      croppedImageUrl = null;
      emit(EventImageDeleteSuccess());
    } catch (error) {
      _logger.e('Image deletion failed: $error');
      emit(ImageUploaderError("Image deletion failed: $error"));
    }
  }
}