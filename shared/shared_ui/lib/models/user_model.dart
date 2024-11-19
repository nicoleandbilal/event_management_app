// user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;
  final String email;
  final String firstName; // First Name
  final String lastName;  // Last Name
  final String role; // Role: admin, organizer, staff, etc.
  final List<String> brandIds; // List of brand IDs this user manages
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  User({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.brandIds,
    required this.createdAt,
    this.updatedAt,
  });

  // Combine first and last name into a full name
  String get fullName => '$firstName $lastName';

  // Convert Firestore document to User model
  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      userId: doc.id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      role: data['role'] ?? 'organizer', // Default role: organizer
      brandIds: List<String>.from(data['brandIds'] ?? []),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  // Convert User model to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'brandIds': brandIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
