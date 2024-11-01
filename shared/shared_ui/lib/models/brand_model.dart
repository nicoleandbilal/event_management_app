// brand_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Brand {
  final String brandId;
  final String userId; // Foreign key to relate to the User
  final String brandName;
  final String? brandLogoImageFullUrl;
  final String? brandLogoImageCroppedUrl;
  final String category; // e.g., Entertainment, Corporate, etc.
  final String? status; // e.g. draft, live, archived
  final String? brandDescription;
  final List<String> teamMembers; // List of user IDs that manage this brand
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  Brand({
    required this.brandId,
    required this.userId,
    required this.brandName,
    this.brandLogoImageFullUrl,
    this.brandLogoImageCroppedUrl,
    required this.category,
    required this.status,
    this.brandDescription,
    required this.teamMembers,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert Firestore document to Brand model
  factory Brand.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Brand(
      brandId: doc.id,
      userId: data['userId'],
      brandName: data['brandName'] ?? '',
      brandLogoImageFullUrl: data['brandLogoImageFullUrl'],
      brandLogoImageCroppedUrl: data['brandLogoImageCroppedUrl'],
      category: data['category'] ?? 'Other',
      status: data['status'] ?? 'draft',
      brandDescription: data['brandDescription'],
      teamMembers: List<String>.from(data['teamMembers'] ?? []),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  // Convert Brand model to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'brandName': brandName,
      'brandLogoImageFullUrl': brandLogoImageFullUrl,
      'brandLogoImageCroppedUrl': brandLogoImageCroppedUrl,
      'category': category,
      'status': status,
      'brandDescription': brandDescription,
      'teamMembers': teamMembers,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
