// image_repository.dart

import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class ImageRepository {
  final FirebaseStorage _storage;
  final Logger _logger = Logger();

  ImageRepository({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Compresses the provided image file and returns the compressed version.
  Future<File> compressImage(File imageFile) async {
    try {
      final compressedXFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        '${imageFile.absolute.path}_compressed.jpg',
        quality: 80,
      );
      return compressedXFile == null ? imageFile : File(compressedXFile.path);
    } catch (e) {
      _logger.e('Image compression failed: $e');
      throw Exception('Image compression failed: $e');
    }
  }

  /// Uploads an image to Firebase Storage and returns the download URL.
  Future<String> uploadImage(File imageFile, String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      _logger.e('Image upload failed: $e');
      throw Exception('Image upload failed: $e');
    }
  }

  /// Deletes all cover images associated with an event by event ID.
  Future<void> deleteEventCoverImages(String eventId) async {
    try {
      final eventFolder = 'events/$eventId/event_cover_image/';
      final folderRef = _storage.ref().child(eventFolder);
      final files = await folderRef.listAll();

      for (final fileRef in files.items) {
        await fileRef.delete();
        _logger.i("Deleted cover image: ${fileRef.fullPath}");
      }

      _logger.i("All cover images deleted for event ID: $eventId");
    } catch (e) {
      _logger.e('Failed to delete cover images: $e');
      throw Exception('Failed to delete cover images: $e');
    }
  }
}
