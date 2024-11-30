import 'dart:io';
import 'package:shared/repositories/image_repository.dart';
import 'package:logger/logger.dart';

/// Service responsible for handling image uploads and deletions for event cover images.
class ImageUploadService {
  final ImageRepository _imageRepository;
  final Logger _logger;

  static const String fullImageError = "Failed to upload full image.";
  static const String croppedImageError = "Failed to upload cropped image.";
  static const String deletionError = "Failed to delete cover images.";

  ImageUploadService(this._imageRepository, this._logger);

  /// Uploads both full and cropped images and returns their URLs in a map.
  Future<Map<String, String?>> uploadFullAndCroppedImages(
      File fullImage, File croppedImage, String eventId) async {
    final sanitizedEventId = _sanitizeEventId(eventId);
    int retryCount = 3;

    for (int attempt = 0; attempt < retryCount; attempt++) {
      try {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fullImagePath =
            'events/$sanitizedEventId/event_cover_image/${timestamp}_full.jpg';
        final croppedImagePath =
            'events/$sanitizedEventId/event_cover_image/${timestamp}_cropped.jpg';

        final fullImageFile = await _imageRepository.compressImage(fullImage);
        final fullUrl =
            await _imageRepository.uploadImage(fullImageFile, fullImagePath);
        if (fullUrl == null) throw ImageUploadException(fullImageError);

        final croppedImageFile =
            await _imageRepository.compressImage(croppedImage);
        final croppedUrl =
            await _imageRepository.uploadImage(croppedImageFile, croppedImagePath);
        if (croppedUrl == null) throw ImageUploadException(croppedImageError);

        _logger.i("Full Image URL: $fullUrl");
        _logger.i("Cropped Image URL: $croppedUrl");

        return {'fullImageUrl': fullUrl, 'croppedImageUrl': croppedUrl};
      } catch (e) {
        if (attempt == retryCount - 1) {
          _logger.e("Image upload failed after $retryCount attempts.", error: e);
          rethrow;
        }
        await Future.delayed(const Duration(seconds: 2)); // Delay before retrying
      }
    }

    throw ImageUploadException('Image upload failed.');
  }

  /// Deletes all cover images associated with a given event ID.
  Future<void> deleteEventCoverImages(String eventId) async {
    final sanitizedEventId = _sanitizeEventId(eventId);

    try {
      await _imageRepository.deleteEventCoverImages(sanitizedEventId);
      _logger.i("Cover images deleted successfully for event ID: $sanitizedEventId");
    } catch (e) {
      _logger.e(deletionError, error: e);
      throw ImageUploadException(deletionError);
    }
  }

  /// Sanitizes the event ID to ensure it is safe for file paths.
  String _sanitizeEventId(String eventId) {
    final sanitized = eventId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '');
    if (sanitized != eventId) {
      _logger.w("Sanitized eventId: $sanitized");
    }
    return sanitized;
  }
}

/// Custom exception for handling specific image upload errors.
class ImageUploadException implements Exception {
  final String message;
  ImageUploadException(this.message);

  @override
  String toString() => "ImageUploadException: $message";
}
