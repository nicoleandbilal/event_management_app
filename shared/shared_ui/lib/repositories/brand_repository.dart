import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/brand_model.dart';

class BrandRepository {
  final FirebaseFirestore firestore;

  BrandRepository({required this.firestore});

  // Method to create a brand with draft status
  Future<String> createDraftBrand(Brand brand) async {
    try {
      final docRef = await firestore.collection('brands').add({
        ...brand.toJson(),
        'status': 'draft', // Ensure status is set to draft on creation
        'createdAt': Timestamp.now(),
        'updatedAt': null,
      });
      return docRef.id; // Return the Firestore-generated brand ID
    } catch (e) {
      throw Exception('Failed to create draft brand: $e');
    }
  }

  // Method to update brand status to live
  Future<void> submitBrand(Brand brand) async {
    try {
      await firestore.collection('brands').doc(brand.brandId).update({
        ...brand.toJson(),
        'status': 'live',
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to submit brand: $e');
    }
  }

  // Fetch brand details from Firestore using brandId
  Future<Brand> getBrandDetails(String brandId) async {
    try {
      final DocumentSnapshot doc = await firestore.collection('brands').doc(brandId).get();
      if (doc.exists) {
        return Brand.fromDocument(doc); // Convert Firestore document to Brand model
      } else {
        throw Exception('Brand not found');
      }
    } catch (e) {
      throw Exception('Error fetching brand details: $e');
    }
  }

  // Fetch multiple brands by a list of brand IDs
Future<List<Brand>> getBrandsByIds(List<String> brandIds) async {
  try {
    if (brandIds.isEmpty) return [];

    List<Brand> brands = [];
    final chunks = _splitList(brandIds, 10);

    for (var chunk in chunks) {
      final QuerySnapshot querySnapshot = await firestore
          .collection('brands')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      brands.addAll(querySnapshot.docs.map((doc) => Brand.fromDocument(doc)).toList());
    }
    return brands;
  } catch (e) {
    throw Exception('Error fetching brands: $e');
  }
}

// Utility function to split list
List<List<T>> _splitList<T>(List<T> list, int chunkSize) {
  return List.generate(
    (list.length / chunkSize).ceil(),
    (i) => list.sublist(
      i * chunkSize,
      (i * chunkSize + chunkSize).clamp(0, list.length),
    ),
  );
}
}