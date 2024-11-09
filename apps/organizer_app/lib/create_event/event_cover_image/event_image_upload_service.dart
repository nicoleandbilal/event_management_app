import 'dart:io';
import 'package:shared/repositories/image_repository.dart';
import 'package:logger/logger.dart';

/// Service responsible for handling image uploads, specifically uploading
/// full and cropped versions of an image for event cover images.
class ImageUploadService {
  final ImageRepository _imageRepository;
  final Logger _logger;

  // Define specific error messages as constants for reuse and clarity
  static const String fullImageError = "Failed to upload full image.";
  static const String croppedImageError = "Failed to upload cropped image.";

  // Constructor that injects dependencies: ImageRepository and Logger for logging
  ImageUploadService(this._imageRepository, this._logger);

  /// Uploads both full and cropped images and returns their URLs in a map with keys
  /// `fullImageUrl` and `croppedImageUrl`. If an upload fails, an `ImageUploadException` is thrown.
  Future<Map<String, String?>> uploadFullAndCroppedImages(File fullImage, File croppedImage, String eventId) async {
    try {
      // Generate unique file paths for the full and cropped images based on the event ID and timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fullImagePath = 'events/$eventId/event_cover_image/${timestamp}_full.jpg';
      final croppedImagePath = 'events/$eventId/event_cover_image/${timestamp}_cropped.jpg';

      // Compress and upload the full image
      final fullImageFile = await _compressImage(fullImage);  // Compress the image file
      final fullUrl = await _imageRepository.uploadImage(fullImageFile, fullImagePath);

      // Check if the URL for the full image is null, and throw an error if so
      if (fullUrl == null) throw ImageUploadException(fullImageError);

      // Compress and upload the cropped image
      final croppedImageFile = await _compressImage(croppedImage);
      final croppedUrl = await _imageRepository.uploadImage(croppedImageFile, croppedImagePath);

      // Check if the URL for the cropped image is null, and throw an error if so
      if (croppedUrl == null) throw ImageUploadException(croppedImageError);

      // Log URLs for debugging and verification
      _logger.i("Full Image URL: $fullUrl");
      _logger.i("Cropped Image URL: $croppedUrl");

      // Return the URLs in a map
      return {'fullImageUrl': fullUrl, 'croppedImageUrl': croppedUrl};
    } catch (e) {
      // Log the error and rethrow it to be handled by the UI or Bloc layer
      _logger.e("Error uploading images", error: e);
      rethrow; 
    }
  }

  /// Helper method to compress images before uploading, using the repository's compression method.
  Future<File> _compressImage(File image) async {
    return await _imageRepository.compressImage(image);
  }
}

/// Custom exception for handling specific image upload errors,
/// making error messages more descriptive and handling easier.
class ImageUploadException implements Exception {
  final String message;
  ImageUploadException(this.message);

  @override
  String toString() => "ImageUploadException: $message";
}
