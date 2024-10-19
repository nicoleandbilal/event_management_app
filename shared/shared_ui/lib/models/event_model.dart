import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String name;
  final String details;

  Event({
    required this.id,
    required this.name,
    required this.details,
  });

  // Factory method to create Event from Firestore document
  factory Event.fromDocument(DocumentSnapshot doc) {
    return Event(
      id: doc.id,
      name: doc['name'],   // Ensure 'name' field exists in Firestore
      details: doc['details'], // Ensure 'details' field exists in Firestore
    );
  }
}
