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
      if (brandIds.isEmpty) return []; // Return empty list if no IDs provided

      print('Fetching brands with IDs: $brandIds');

      final QuerySnapshot querySnapshot = await firestore
          .collection('brands')
          .where(FieldPath.documentId, whereIn: brandIds)
          .get();

      final brands = querySnapshot.docs.map((doc) => Brand.fromDocument(doc)).toList();
      print('Retrieved brands: ${brands.map((b) => b.brandName).toList()}');
      
      return brands;
    } catch (e) {
      print('Error fetching brands: $e');
      throw Exception('Error fetching brands');
    }
  }
}