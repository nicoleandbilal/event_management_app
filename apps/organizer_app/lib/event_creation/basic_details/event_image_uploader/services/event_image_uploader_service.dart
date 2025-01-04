import 'dart:io';
import 'package:shared/repositories/image_repository.dart';
import 'package:logger/logger.dart';

class ImageUploadService {
  final ImageRepository _imageRepository;
  final Logger _logger;

  static const String fullImageError = "Failed to upload full image.";
  static const String croppedImageError = "Failed to upload cropped image.";

  ImageUploadService(this._imageRepository, this._logger);

  Future<Map<String, String?>> uploadFullAndCroppedImages(
      File fullImage, File croppedImage, String eventId) async {
    final sanitizedEventId = _sanitizeEventId(eventId);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fullImagePath = 'events/$sanitizedEventId/event_cover_image/${timestamp}_full.jpg';
    final croppedImagePath = 'events/$sanitizedEventId/event_cover_image/${timestamp}_cropped.jpg';

    try {
      // Upload full image
      final compressedFullImage = await _imageRepository.compressImage(fullImage);
      final fullImageUrl = await _imageRepository.uploadImage(compressedFullImage, fullImagePath);
      if (fullImageUrl == null) throw Exception(fullImageError);

      // Upload cropped image
      final compressedCroppedImage = await _imageRepository.compressImage(croppedImage);
      final croppedImageUrl = await _imageRepository.uploadImage(compressedCroppedImage, croppedImagePath);
      if (croppedImageUrl == null) throw Exception(croppedImageError);

      return {'fullImageUrl': fullImageUrl, 'croppedImageUrl': croppedImageUrl};
    } catch (e) {
      _logger.e("Image upload failed.", error: e);
      throw Exception("Error uploading images: $e");
    }
  }

  Future<void> deleteEventCoverImages(String eventId) async {
    final sanitizedEventId = _sanitizeEventId(eventId);

    try {
      await _imageRepository.deleteEventCoverImages(sanitizedEventId);
      _logger.i("Cover images deleted successfully for event ID: $sanitizedEventId");
    } catch (e) {
      _logger.e("Failed to delete cover images.", error: e);
    }
  }

  String _sanitizeEventId(String eventId) {
    return eventId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '');
  }
}