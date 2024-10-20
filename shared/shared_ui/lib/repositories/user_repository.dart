import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/user_model.dart';
import 'package:logger/logger.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final Logger _logger = Logger();

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Fetch user data from Firestore
  Future<UserModel> getUserData(String uid) async {
    try {
      _logger.i('UserRepository: Fetching user data for UID: $uid');

      // Fetch the document for the user from Firestore
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        _logger.i('UserRepository: User document found for UID: $uid');
        return UserModel.fromMap(doc.data()!, uid);  // Convert Firestore data to UserModel
      } else {
        _logger.e('UserRepository: No user document found for UID: $uid');
        throw Exception('User not found');
      }
    } catch (e) {
      _logger.e('UserRepository: Error fetching user data: $e');
      throw Exception('Failed to fetch user data.');
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData(UserModel user) async {
    try {
      _logger.i('UserRepository: Updating user data for UID: ${user.uid}');
      
      // Update the user document in Firestore
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      _logger.i('UserRepository: User data updated successfully.');
    } catch (e) {
      _logger.e('UserRepository: Error updating user data: $e');
      throw Exception('Failed to update user data.');
    }
  }

  // Add an event to the user's organized events list
  Future<void> addOrganizedEvent(String uid, String eventId) async {
    try {
      _logger.i('UserRepository: Adding organized event for UID: $uid');
      
      // Update Firestore to add the eventId to the user's organizedEvents list
      await _firestore.collection('users').doc(uid).update({
        'organizedEvents': FieldValue.arrayUnion([eventId]),
      });
      _logger.i('UserRepository: Event $eventId added to organized events.');
    } catch (e) {
      _logger.e('UserRepository: Error adding organized event: $e');
      throw Exception('Failed to add organized event.');
    }
  }

  // Add an event to the user's attended events list
  Future<void> addAttendedEvent(String uid, String eventId) async {
    try {
      _logger.i('UserRepository: Adding attended event for UID: $uid');
      
      // Update Firestore to add the eventId to the user's attendedEvents list
      await _firestore.collection('users').doc(uid).update({
        'attendedEvents': FieldValue.arrayUnion([eventId]),
      });
      _logger.i('UserRepository: Event $eventId added to attended events.');
    } catch (e) {
      _logger.e('UserRepository: Error adding attended event: $e');
      throw Exception('Failed to add attended event.');
    }
  }

  // Check if a user has already attended a specific event
  Future<bool> hasAttendedEvent(String uid, String eventId) async {
    try {
      _logger.i('UserRepository: Checking if user $uid has attended event $eventId');
      
      // Fetch the user's document from Firestore
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        final data = doc.data();
        final attendedEvents = List<String>.from(data?['attendedEvents'] ?? []);
        
        // Check if the eventId exists in the attendedEvents list
        return attendedEvents.contains(eventId);
      }
      return false;
    } catch (e) {
      _logger.e('UserRepository: Error checking attended event: $e');
      throw Exception('Failed to check attended event.');
    }
  }
}
