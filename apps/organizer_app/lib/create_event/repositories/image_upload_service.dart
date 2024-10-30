import 'dart:io';
import 'image_repository.dart';

class ImageUploadService {
  final ImageRepository _imageRepository;

  ImageUploadService(this._imageRepository);

  Future<Map<String, String?>> uploadFullAndCroppedImages(File fullImage, File croppedImage) async {
    try {
      final fullImagePath = 'event_images/${DateTime.now().millisecondsSinceEpoch}_full.jpg';
      final croppedImagePath = 'event_images/${DateTime.now().millisecondsSinceEpoch}_cropped.jpg';

      // Upload full image
      final fullUrl = await _imageRepository.uploadImage(
        await _imageRepository.compressImage(fullImage),
        fullImagePath,
      );

      // Check if full URL is null
      if (fullUrl == null) {
        throw Exception("Failed to upload full image.");
      }

      // Upload cropped image
      final croppedUrl = await _imageRepository.uploadImage(
        await _imageRepository.compressImage(croppedImage),
        croppedImagePath,
      );

      // Check if cropped URL is null
      if (croppedUrl == null) {
        throw Exception("Failed to upload cropped image.");
      }

      // Log URLs for debugging
      print("Full Image URL: $fullUrl");
      print("Cropped Image URL: $croppedUrl");

      return {'fullImageUrl': fullUrl, 'croppedImageUrl': croppedUrl};
    } catch (e) {
      print("Error uploading images: $e");
      rethrow; // Re-throw the error to handle it in the UI or Bloc
    }
  }
}

