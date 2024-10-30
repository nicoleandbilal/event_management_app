import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/brand_model.dart';

class BrandRepository {
  final FirebaseFirestore firestore;

  BrandRepository({required this.firestore});

  // Fetch event details from Firestore using eventId
  Future<Brand> getBrandDetails(String brandId) async {
    try {
      // Retrieve event document by ID
      final DocumentSnapshot doc =
          await firestore.collection('brands').doc(brandId).get();
      if (doc.exists) {
        // Convert the Firestore document into an Event model using fromDocument
        return Brand.fromDocument(doc);
      } else {
        throw Exception('Event not found');
      }
    } catch (e) {
      throw Exception('Error fetching brand details: $e');
    }
  }

  Future<void> submitBrand(Brand brand) async {
    try {
      await firestore.collection('brands').add({
        'brandName': brand.brandName,
        'brandLogoImageFullUrl': brand.brandLogoImageFullUrl,
        'brandLogoImageCroppedUrl': brand.brandLogoImageCroppedUrl,
        'category': brand.category,
        'brandDescription': brand.brandDescription,
        'teamMembers': brand.teamMembers,
        'createdAt': brand.createdAt,
        'updatedAt': brand.updatedAt,
      });
    } catch (e) {
      throw Exception('Failed to submit brand: $e');
    }
  }
}
