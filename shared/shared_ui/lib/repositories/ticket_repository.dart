// ticket_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/ticket_mapper.dart';
import 'package:shared/models/ticket_model.dart';


class TicketRepository {
  final FirebaseFirestore firestore;

  TicketRepository({required this.firestore});

  // Save or update a ticket under the event's tickets subcollection
  Future<void> saveTicket(String eventId, Ticket ticket) async {
    try {
      final ticketRef = firestore
          .collection('events')
          .doc(eventId)
          .collection('tickets')
          .doc(ticket.ticketId);

      await ticketRef.set(TicketMapper.toFirestore(ticket));
    } catch (e) {
      throw Exception('Failed to save ticket: $e');
    }
  }

  // Fetch all tickets for a specific event
  Future<List<Ticket>> getTickets(String eventId) async {
    try {
      final ticketCollection = await firestore
          .collection('events')
          .doc(eventId)
          .collection('tickets')
          .get();

      return ticketCollection.docs.map((doc) => TicketMapper.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tickets: $e');
    }
  }

  // Delete a ticket by ID within the event's tickets subcollection
  Future<void> deleteTicket(String eventId, String ticketId) async {
    try {
      await firestore
          .collection('events')
          .doc(eventId)
          .collection('tickets')
          .doc(ticketId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete ticket: $e');
    }
  }
}
