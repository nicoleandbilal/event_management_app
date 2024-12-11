import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/src/logger.dart';
import 'package:shared/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({required FirebaseFirestore firestore, required Logger logger}) : _firestore = firestore;

  /// Create a new user in Firestore
  Future<void> createUser({
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
    String role = 'organizer', // Default role is organizer
  }) async {
    try {
      final newUser = User(
        userId: userId,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
        brandIds: [],
        createdAt: Timestamp.now(),
        updatedAt: null,
      );

      await _firestore.collection('users').doc(userId).set(newUser.toJson());
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  /// Fetch a user by their userId from Firestore
  Future<User?> getUserById(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        return User.fromDocument(doc);
      } else {
        return null; // User not found
      }
    } catch (e) {
      throw Exception('Error fetching user by ID: $e');
    }
  }

  /// Update an existing user's details
  Future<void> updateUser({
    required String userId,
    String? firstName,
    String? lastName,
    String? role,
    List<String>? brandIds,
  }) async {
    try {
      final updateData = <String, dynamic>{
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (role != null) 'role': role,
        if (brandIds != null) 'brandIds': brandIds,
        'updatedAt': Timestamp.now(), // Update timestamp on modification
      };

      await _firestore.collection('users').doc(userId).update(updateData);
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  /// Delete a user from Firestore by userId
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  /// Fetch a list of users by their role (e.g., admin, organizer)
  Future<List<User>> getUsersByRole(String role) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: role)
          .get();

      return querySnapshot.docs.map((doc) => User.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching users by role: $e');
    }
  }

  /// Attach a new brand to the user's brandIds array
  Future<void> addBrandToUser({
    required String userId,
    required String brandId,
  }) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      await userRef.update({
        'brandIds': FieldValue.arrayUnion([brandId]),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Error adding brand to user: $e');
    }
  }

  /// Remove a brand from the user's brandIds array
  Future<void> removeBrandFromUser({
    required String userId,
    required String brandId,
  }) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      await userRef.update({
        'brandIds': FieldValue.arrayRemove([brandId]),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Error removing brand from user: $e');
    }
  }
}