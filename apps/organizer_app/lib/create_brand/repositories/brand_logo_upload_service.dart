import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:organizer_app/create_brand/brand_logo_image_repository.dart';

class BrandLogoUploadException implements Exception {
  final String message;
  BrandLogoUploadException(this.message);

  @override
  String toString() => "BrandLogoUploadException: $message";
}

class BrandLogoUploadService {
  final BrandLogoImageRepository _imageRepository;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  BrandLogoUploadService(this._imageRepository);

  Future<Map<String, String>?> pickAndUploadImage(String brandId) async {
    if (_isUploading) {
      print("Uploader is already in use."); // Debugging statement
      return null;
    }
    _isUploading = true;

    try {
      print("Picking image...");
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1920, maxHeight: 1080);
      if (pickedFile == null) {
        print("Image picking was cancelled.");
        return null;
      }

      final File fullImageFile = File(pickedFile.path);
      print("Image picked successfully, starting cropping...");

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: fullImageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
        compressQuality: 85,
        maxWidth: 1600,
        maxHeight: 900,
      );

      if (croppedFile == null) {
        print("Cropping was cancelled.");
        return null;
      }

      print("Cropping successful, starting compression...");
      final croppedImageFile = File(croppedFile.path);
      final compressedFullImageFile = await _imageRepository.compressImage(fullImageFile);
      final compressedCroppedImageFile = await _imageRepository.compressImage(croppedImageFile);

      print("Compression complete, starting upload...");
      final imageUrls = await _imageRepository.uploadFullAndCroppedImage(
        fullImageFile: compressedFullImageFile,
        croppedImageFile: compressedCroppedImageFile,
        fullImagePath: 'brand_logos/$brandId/full_${DateTime.now().millisecondsSinceEpoch}.jpg',
        croppedImagePath: 'brand_logos/$brandId/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      print("Upload successful with URLs: $imageUrls");
      return imageUrls;
    } catch (e) {
      print("Error during image upload process: $e");
      throw BrandLogoUploadException("Failed to upload image: $e");
    } finally {
      _isUploading = false;
      print("Reset _isUploading to false.");
    }
  }
}
