import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/ticket_mapper.dart';
import '../models/ticket_model.dart';

class TicketRepository {
  final FirebaseFirestore firestore;
  final Logger _logger = Logger();

  TicketRepository({
    required this.firestore,
  });

  /// Creates a draft ticket and returns the generated ticket ID
  Future<String> createDraftTicket(String eventId, Ticket ticket) async {
    try {
      final ticketRef = firestore
          .collection('events')
          .doc(eventId)
          .collection('tickets')
          .doc(); // Generate a new document ID
      await ticketRef.set(TicketMapper.toFirestore(ticket));
      _logger.i('Draft ticket created for event ID: $eventId, ticket ID: ${ticketRef.id}');
      return ticketRef.id;
    } catch (e) {
      _logger.e('Failed to create draft ticket for event ID: $eventId. Error: $e');
      throw Exception('Failed to create draft ticket.');
    }
  }

  /// Updates an existing draft ticket or creates it if it doesn't exist
  Future<void> updateDraftTicket(String eventId, Ticket ticket) async {
    try {
      final ticketRef = firestore
          .collection('events')
          .doc(eventId)
          .collection('tickets')
          .doc(ticket.ticketId); // Use the provided ticket ID
      await ticketRef.set(TicketMapper.toFirestore(ticket));
      _logger.i('Ticket updated for event ID: $eventId, ticket ID: ${ticket.ticketId}');
    } catch (e) {
      _logger.e('Failed to update ticket for event ID: $eventId, ticket ID: ${ticket.ticketId}. Error: $e');
      throw Exception('Failed to update ticket.');
    }
  }

  /// Saves all tickets for an event in a batch operation
  Future<void> saveAllTickets(String eventId, List<Ticket> tickets) async {
    final batch = firestore.batch();
    try {
      for (var ticket in tickets) {
        final ticketRef = firestore
            .collection('events')
            .doc(eventId)
            .collection('tickets')
            .doc(ticket.ticketId);
        batch.set(ticketRef, TicketMapper.toFirestore(ticket));
      }
      await batch.commit();
      _logger.i('All tickets saved for event ID: $eventId');
    } catch (e) {
      _logger.e('Failed to save all tickets for event ID: $eventId. Error: $e');
      throw Exception('Failed to save tickets.');
    }
  }

  /// Fetches all tickets for a specific event
  Future<List<Ticket>> getTickets(String eventId) async {
    try {
      final ticketCollection = await firestore
          .collection('events')
          .doc(eventId)
          .collection('tickets')
          .get();
      _logger.i('Fetched ${ticketCollection.docs.length} tickets for event ID: $eventId');
      return ticketCollection.docs
          .map((doc) => TicketMapper.fromFirestore(doc))
          .toList();
    } catch (e) {
      _logger.e('Failed to fetch tickets for event ID: $eventId. Error: $e');
      throw Exception('Failed to fetch tickets.');
    }
  }

  /// Deletes a specific ticket by ID
  Future<void> deleteTicket(String eventId, String ticketId) async {
    try {
      await firestore
          .collection('events')
          .doc(eventId)
          .collection('tickets')
          .doc(ticketId)
          .delete();
      _logger.i('Ticket deleted for event ID: $eventId, ticket ID: $ticketId');
    } catch (e) {
      _logger.e('Failed to delete ticket for event ID: $eventId, ticket ID: $ticketId. Error: $e');
      throw Exception('Failed to delete ticket.');
    }
  }
}