// event_image_upload_service.dart

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
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fullImagePath = 'events/$eventId/event_cover_image/${timestamp}_full.jpg';
      final croppedImagePath = 'events/$eventId/event_cover_image/${timestamp}_cropped.jpg';

      final fullImageFile = await _imageRepository.compressImage(fullImage);
      final fullUrl = await _imageRepository.uploadImage(fullImageFile, fullImagePath);
      if (fullUrl == null) throw ImageUploadException(fullImageError);

      final croppedImageFile = await _imageRepository.compressImage(croppedImage);
      final croppedUrl = await _imageRepository.uploadImage(croppedImageFile, croppedImagePath);
      if (croppedUrl == null) throw ImageUploadException(croppedImageError);

      _logger.i("Full Image URL: $fullUrl");
      _logger.i("Cropped Image URL: $croppedUrl");

      return {'fullImageUrl': fullUrl, 'croppedImageUrl': croppedUrl};
    } catch (e) {
      _logger.e("Error uploading images", error: e);
      rethrow;
    }
  }

  /// Deletes all cover images associated with a given event ID.
  Future<void> deleteEventCoverImages(String eventId) async {
    try {
      await _imageRepository.deleteEventCoverImages(eventId);
      _logger.i("Cover images deleted successfully for event ID: $eventId");
    } catch (e) {
      _logger.e(deletionError, error: e);
      throw ImageUploadException(deletionError);
    }
  }
}

/// Custom exception for handling specific image upload errors.
class ImageUploadException implements Exception {
  final String message;
  ImageUploadException(this.message);

  @override
  String toString() => "ImageUploadException: $message";
}
