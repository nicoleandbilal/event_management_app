// ticket_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketRepository {
  final FirebaseFirestore firestore;

  TicketRepository({required this.firestore});

  // Saves or updates a single ticket document
  Future<void> saveTicketDetails(String eventId, Map<String, dynamic> ticketData) async {
    try {
      final ticketCollection = firestore.collection('events').doc(eventId).collection('tickets');
      final ticketId = ticketData['ticketId'] ?? ticketCollection.doc().id;
      ticketData['ticketId'] = ticketId;

      await ticketCollection.doc(ticketId).set(ticketData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save ticket details: $e');
    }
  }

  // Bulk save or update for multiple tickets using batch write
  Future<void> saveMultipleTickets(String eventId, List<Map<String, dynamic>> ticketList) async {
    WriteBatch batch = firestore.batch();
    final ticketCollection = firestore.collection('events').doc(eventId).collection('tickets');

    for (var ticketData in ticketList) {
      final ticketId = ticketData['ticketId'] ?? ticketCollection.doc().id;
      ticketData['ticketId'] = ticketId;
      batch.set(ticketCollection.doc(ticketId), ticketData, SetOptions(merge: true));
    }
    await batch.commit();
  }

  // Real-time listener for tickets in a specific event
  Stream<List<Map<String, dynamic>>> streamTickets(String eventId) {
    return firestore
        .collection('events')
        .doc(eventId)
        .collection('tickets')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Retrieves a paginated list of tickets
  Future<List<Map<String, dynamic>>> getPaginatedTickets(
    String eventId, {DocumentSnapshot? lastDoc, int limit = 20}
  ) async {
    final query = firestore.collection('events').doc(eventId).collection('tickets').limit(limit);
    if (lastDoc != null) query.startAfterDocument(lastDoc);

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Deletes a ticket by ticketId
  Future<void> deleteTicket(String eventId, String ticketId) async {
    try {
      await firestore.collection('events').doc(eventId).collection('tickets').doc(ticketId).delete();
    } catch (e) {
      throw Exception('Failed to delete ticket: $e');
    }
  }
}
