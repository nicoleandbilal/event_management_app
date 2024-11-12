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

      await ticketRef.set(TomaTicketMapper.toFirestore(ticket));
    } catch (e) {
      throw Exception('Failed to save ticket: $e');
    }
  }

  // Create a draft ticket with a "draft" status
  Future<String> createDraftTicket(String eventId, Ticket ticket) async {
    try {
      final ticketCollectionRef = firestore
          .collection('events')
          .doc(eventId)
          .collection('tickets');

      final docRef = await ticketCollectionRef.add({
        ...TomaTicketMapper.toFirestore(ticket),
        'status': 'draft',  // Ensure status is set to draft on creation
        'createdAt': Timestamp.now(),
        'updatedAt': null,
      });
      return docRef.id; // Return the Firestore-generated ticket ID
    } catch (e) {
      throw Exception('Failed to create draft ticket: $e');
    }
  }

  // Updates a draft ticket with partial data (e.g., from form progress) and changes status to 'draft'
  Future<void> updateDraftTicket(String eventId, String ticketId, Map<String, dynamic> updatedData) async {
    try {
      updatedData['status'] = 'draft';  // Set status to 'draft'
      updatedData['updatedAt'] = Timestamp.fromDate(DateTime.now());  // Update timestamp
      await firestore
          .collection('events')
          .doc(eventId)
          .collection('tickets')
          .doc(ticketId)
          .update(updatedData);
    } catch (e) {
      throw Exception('Failed to update draft ticket: $e');
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

      return ticketCollection.docs.map((doc) => TomaTicketMapper.fromFirestore(doc)).toList();
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
