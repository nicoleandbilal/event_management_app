import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/brand_model.dart';

class BrandRepository {
  final FirebaseFirestore firestore;

  BrandRepository({required this.firestore});

  Future<void> submitBrand(Brand brand) async {
    try {
      await firestore.collection('brands').add({
        'brandName': brand.brandName,
        'brandLogoImageFullUrl': brand.brandLogoImageFullUrl,
        'brandLogoImageCroppedUrl': brand.brandLogoImageCroppedUrl,
        'category': brand.category,
        'teamMembers': brand.teamMembers,
        'createdAt': brand.createdAt,
        'updatedAt': brand.updatedAt,
      });
    } catch (e) {
      throw Exception('Failed to submit brand: $e');
    }
  }
}
