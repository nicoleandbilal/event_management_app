import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/blocs/event_image_uploader_event.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/blocs/event_image_uploader_state.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/services/event_image_uploader_service.dart';


class ImageUploaderBloc extends Bloc<ImageUploaderEvent, ImageUploaderState> {
  final ImageUploaderService _imageUploaderService;

  ImageUploaderBloc(this._imageUploaderService) : super(ImageUploaderInitial()) {
    on<UploadEventImage>(_onUploadEventImage);
    on<DeleteEventImage>(_onDeleteEventImage);
  }

  Future<void> _onUploadEventImage(
      UploadEventImage event, Emitter<ImageUploaderState> emit) async {
    emit(EventImageUploading());
    try {
      final imageUrls = await _imageUploaderService.uploadFullAndCroppedImages(
        event.fullImage,
        event.croppedImage,
        event.eventId,
      );

      emit(EventImageUploadSuccess(
        fullImageUrl: imageUrls['fullImageUrl'],
        croppedImageUrl: imageUrls['croppedImageUrl'],
      ));
    } catch (e) {
      emit(ImageUploaderError('Failed to upload images: $e'));
    }
  }

  Future<void> _onDeleteEventImage(
      DeleteEventImage event, Emitter<ImageUploaderState> emit) async {
    emit(EventImageDeleting());
    try {
      await _imageUploaderService.deleteEventCoverImages(event.eventId);
      emit(EventImageDeleteSuccess());
    } catch (e) {
      emit(ImageUploaderError('Failed to delete images: $e'));
    }
  }
}