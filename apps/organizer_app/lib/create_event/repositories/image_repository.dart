import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageRepository {
  final FirebaseStorage _storage;

  ImageRepository({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  // Compress the image before uploading
  Future<File> compressImage(File imageFile) async {
    try {
      // Compress the image and handle the XFile return type
      final XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path, // Original image path
        '${imageFile.absolute.path}_compressed.jpg', // Path for the compressed image
        quality: 80, // Adjust quality as needed
      );

      // If compression fails and returns null, return the original image file
      if (compressedXFile == null) {
        return imageFile;
      }

      // Convert XFile to File
      return File(compressedXFile.path);
    } catch (e) {
      throw Exception('Image compression failed: $e');
    }
  }

  // Upload image to Firebase and return the download URL
  Future<String> uploadImage(File imageFile, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(imageFile);
      if (uploadTask.state == TaskState.success) {
        return await ref.getDownloadURL();
      } else {
        throw Exception('Image upload failed with state: ${uploadTask.state}');
      }
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  // Upload full and cropped image
  Future<Map<String, String>> uploadFullAndCroppedImage({
    required File fullImageFile,
    required File croppedImageFile,
    required String fullImagePath,
    required String croppedImagePath,
  }) async {
    final eventCoverImageFullUrl = await uploadImage(fullImageFile, fullImagePath);
    final eventCoverImageCroppedUrl = await uploadImage(croppedImageFile, croppedImagePath);
    return {
      'eventCoverImageFullUrl': eventCoverImageFullUrl,
      'eventCoverImageCroppedUrl': eventCoverImageCroppedUrl,
    };
  }
}