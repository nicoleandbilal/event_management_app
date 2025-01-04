import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/blocs/event_image_uploader_event.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/blocs/event_image_uploader_state.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/services/event_image_uploader_service.dart';

class ImageUploaderBloc extends Bloc<ImageUploaderEvent, ImageUploaderState> {
  final ImageUploadService _imageUploadService;
  final String eventId;

  ImageUploaderBloc(this._imageUploadService, this.eventId) : super(ImageUploaderInitial()) {
    on<ImagesSelected>(_onImagesSelected);
    on<ImagesDeleted>(_onImagesDeleted);
  }

  Future<void> _onImagesSelected(ImagesSelected event, Emitter<ImageUploaderState> emit) async {
    emit(ImageUploading());
    try {
      final result = await _imageUploadService.uploadFullAndCroppedImages(
        event.fullImage,
        event.croppedImage,
        eventId,
      );

      emit(ImagesUploaded(result['fullImageUrl']!, result['croppedImageUrl']!));
    } catch (e) {
      emit(ImageUploaderError("Failed to upload images: $e"));
    }
  }

  Future<void> _onImagesDeleted(ImagesDeleted event, Emitter<ImageUploaderState> emit) async {
    emit(ImageUploaderInitial());
  }
}