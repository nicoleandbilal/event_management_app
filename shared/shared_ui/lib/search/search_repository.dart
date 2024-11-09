import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/event_mapper.dart';
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

      return snapshot.docs.map((doc) => TomaEventMapper.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error searching events: $e');
    }
  }

  // Pagination for loading more results
  Future<List<Event>> searchEventsPaginated(DocumentSnapshot lastDocument) async {
    try {
      final snapshot = await firestore
          .collection('events')
          .orderBy('eventName')
          .startAfterDocument(lastDocument)
          .limit(20)
          .get();

      return snapshot.docs.map((doc) => TomaEventMapper.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error loading more events: $e');
    }
  }
}
