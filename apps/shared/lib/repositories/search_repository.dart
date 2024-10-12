import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/event_model.dart';

class SearchRepository {
  final FirebaseFirestore firestore;

  SearchRepository({required this.firestore});

  // Method to search events in Firestore based on a query
  Future<List<Event>> searchEvents(String query) async {
    // Firestore query to search for events where the name contains the search query
    final snapshot = await firestore
        .collection('events') // Your Firestore collection name
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    // Mapping Firestore documents to Event model instances
    return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
  }
}