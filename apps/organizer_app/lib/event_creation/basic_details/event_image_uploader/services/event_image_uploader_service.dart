import 'dart:io';
import 'package:shared/repositories/image_repository.dart';

class ImageUploaderService {
  final ImageRepository _imageRepository;

  ImageUploaderService(this._imageRepository);

  Future<Map<String, String?>> uploadFullAndCroppedImages(
    File fullImage,
    File croppedImage,
    String eventId,
  ) async {
    final sanitizedEventId = _sanitizeEventId(eventId);

    final fullImagePath =
        'events/$sanitizedEventId/event_cover_image/full_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final croppedImagePath =
        'events/$sanitizedEventId/event_cover_image/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final fullImageUrl = await _imageRepository.uploadImage(fullImage, fullImagePath);
    final croppedImageUrl = await _imageRepository.uploadImage(croppedImage, croppedImagePath);

    return {
      'fullImageUrl': fullImageUrl,
      'croppedImageUrl': croppedImageUrl,
    };
  }

  Future<void> deleteEventCoverImages(String eventId) async {
    await _imageRepository.deleteEventCoverImages(eventId);
  }

  String _sanitizeEventId(String eventId) {
    return eventId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '');
  }
}