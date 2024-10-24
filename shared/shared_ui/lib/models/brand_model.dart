import 'package:cloud_firestore/cloud_firestore.dart';

class Brand {
  final String brandId;
  final String userId; // Foreign key to relate to the User
  final String name;
  final String? logoUrl; // Optional brand logo
  final String category; // e.g., Entertainment, Corporate, etc.
  final List<String> teamMembers; // List of user IDs that manage this brand
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  Brand({
    required this.brandId,
    required this.userId,
    required this.name,
    this.logoUrl,
    required this.category,
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
      name: data['name'] ?? '',
      logoUrl: data['logoUrl'],
      category: data['category'] ?? 'Other',
      teamMembers: List<String>.from(data['teamMembers'] ?? []),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  // Convert Brand model to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'logoUrl': logoUrl,
      'category': category,
      'teamMembers': teamMembers,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
