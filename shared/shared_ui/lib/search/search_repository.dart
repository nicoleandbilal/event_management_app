import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/event_model.dart';

class SearchRepository {
  final FirebaseFirestore firestore;

  SearchRepository({required this.firestore});

  // Initial search query with a limit
  Future<List<Event>> searchEvents(String query) async {
    try {
      final snapshot = await firestore
          .collection('events')
          .orderBy('eventName')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .limit(20)
          .get();

      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error searching events: $e');
    }
  }

  // Fetch the last document for pagination
  Future<DocumentSnapshot?> getLastDocument(String query) async {
    final snapshot = await firestore
        .collection('events')
        .orderBy('eventName')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .limit(20)
        .get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
  }

  // Fetch next set of results (pagination)
  Future<List<Event>> searchEventsPaginated(DocumentSnapshot lastDocument) async {
    try {
      final snapshot = await firestore
          .collection('events')
          .orderBy('eventName')
          .startAfterDocument(lastDocument) // Pagination starts after the last document
          .limit(20)
          .get();

      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error loading more events: $e');
    }
  }

  // Get the last document after pagination
  Future<DocumentSnapshot?> getLastDocumentPaginated(DocumentSnapshot lastDocument) async {
    final snapshot = await firestore
        .collection('events')
        .orderBy('eventName')
        .startAfterDocument(lastDocument)
        .limit(20)
        .get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
  }
}
