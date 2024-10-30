import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BrandLogoImageRepository {
  final FirebaseStorage _storage;

  BrandLogoImageRepository({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

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

  Future<String> uploadImage(File imageFile, String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  Future<Map<String, String>> uploadFullAndCroppedImage({
    required File fullImageFile,
    required File croppedImageFile,
    required String fullImagePath,
    required String croppedImagePath,
  }) async {
    final fullUrl = await uploadImage(fullImageFile, fullImagePath);
    final croppedUrl = await uploadImage(croppedImageFile, croppedImagePath);
    return {
      'brandLogoImageFullUrl': fullUrl,
      'brandLogoImageCroppedUrl': croppedUrl,
    };
  }
}
