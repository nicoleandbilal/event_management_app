// image_repository.dart

import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageRepository {
  final FirebaseStorage _storage;

  ImageRepository({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Compresses the provided image file and returns the compressed version.
  Future<File> compressImage(File imageFile) async {
    try {
      final XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        '${imageFile.absolute.path}_compressed.jpg',
        quality: 80,
      );
      return compressedXFile == null ? imageFile : File(compressedXFile.path);
    } catch (e) {
      throw Exception('Image compression failed: $e');
    }
  }

  /// Uploads an image to the specified path in Firebase Storage and returns the download URL.
  Future<String> uploadImage(File imageFile, String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  /// Uploads both full and cropped images for an event, returning their URLs.
  Future<Map<String, String?>> uploadFullAndCroppedImages(
      File fullImage, File croppedImage, String eventId) async {
    try {
      // Create unique file paths for the images
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fullImagePath = 'events/$eventId/event_cover_image/${timestamp}_full.jpg';
      final croppedImagePath = 'events/$eventId/event_cover_image/${timestamp}_cropped.jpg';

      // Compress and upload both images
      final fullImageFile = await compressImage(fullImage);
      final croppedImageFile = await compressImage(croppedImage);

      final fullImageUrl = await uploadImage(fullImageFile, fullImagePath);
      final croppedImageUrl = await uploadImage(croppedImageFile, croppedImagePath);

      return {
        'fullImageUrl': fullImageUrl,
        'croppedImageUrl': croppedImageUrl,
      };
    } catch (e) {
      throw Exception('Failed to upload images: $e');
    }
  }

  /// Deletes images associated with an event by event ID.
  Future<void> deleteEventImages(String eventId) async {
    try {
      final eventFolder = 'events/$eventId/event_cover_image/';
      final folderRef = _storage.ref().child(eventFolder);

      final files = await folderRef.listAll();
      for (final fileRef in files.items) {
        await fileRef.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete images: $e');
    }
  }
}
