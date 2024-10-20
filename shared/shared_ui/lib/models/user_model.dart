import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;  // Unique user ID (from Firebase or other service)
  final String name;  // User's name
  final String email;  // User's email address
  final String? profilePicture;  // Optional profile picture URL
  final List<String> organizedEvents;  // Event IDs that the user has organized
  final List<String> attendedEvents;  // Event IDs that the user has attended
  final DateTime? joinedDate;  // Date when the user joined the platform
  final Map<String, dynamic>? preferences;  // Optional preferences (e.g., user settings, notifications)

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePicture,
    this.organizedEvents = const [],
    this.attendedEvents = const [],
    this.joinedDate,
    this.preferences,
  });

  // Check if the user has organized any events
  bool get isOrganizer => organizedEvents.isNotEmpty;

  // Check if the user has attended any events
  bool get isAttendee => attendedEvents.isNotEmpty;

  // Check if the user is new (hasn't organized or attended any events)
  bool get isNewUser => organizedEvents.isEmpty && attendedEvents.isEmpty;

  // Create a copy of the UserModel with updated fields (useful for immutability)
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePicture,
    List<String>? organizedEvents,
    List<String>? attendedEvents,
    DateTime? joinedDate,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      organizedEvents: organizedEvents ?? this.organizedEvents,
      attendedEvents: attendedEvents ?? this.attendedEvents,
      joinedDate: joinedDate ?? this.joinedDate,
      preferences: preferences ?? this.preferences,
    );
  }

  // Convert a Firestore document to a UserModel instance
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePicture: data['profilePicture'],
      organizedEvents: List<String>.from(data['organizedEvents'] ?? []),
      attendedEvents: List<String>.from(data['attendedEvents'] ?? []),
      joinedDate: data['joinedDate'] != null ? DateTime.parse(data['joinedDate']) : null,
      preferences: data['preferences'],
    );
  }

  // Convert a UserModel instance to a Firestore document (Map)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'organizedEvents': organizedEvents,
      'attendedEvents': attendedEvents,
      'joinedDate': joinedDate?.toIso8601String(),
      'preferences': preferences,
    };
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        profilePicture,
        organizedEvents,
        attendedEvents,
        joinedDate,
        preferences,
      ];
}
