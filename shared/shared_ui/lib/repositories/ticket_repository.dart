// ticket_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/ticket_mapper.dart';
import '../models/ticket_model.dart';

class TicketRepository {
  final FirebaseFirestore firestore;
  final Logger _logger = Logger();

  TicketRepository({required this.firestore});

  // Create a draft ticket and return the ticket ID
  Future<String> createDraftTicket(String eventId, Ticket ticket) async {
    try {
      final ticketRef = firestore.collection('events').doc(eventId).collection('tickets').doc();
      await ticketRef.set(TomaTicketMapper.toFirestore(ticket));
      _logger.i('Draft ticket created successfully for event ID: $eventId, ticket ID: ${ticketRef.id}');
      return ticketRef.id; // Return the generated document ID
    } catch (e) {
      _logger.e('Failed to create draft ticket for event $eventId: $e');
      throw Exception('Failed to create draft ticket: $e');
    }
  }

  // Update an existing ticket or create if it doesn't exist
  Future<void> updateDraftTicket(String eventId, Ticket ticket) async {
    try {
      final ticketRef = firestore.collection('events').doc(eventId).collection('tickets').doc(ticket.ticketId);
      await ticketRef.set(TomaTicketMapper.toFirestore(ticket));
      _logger.i('Ticket updated or created successfully for event ID: $eventId, ticket ID: ${ticket.ticketId}');
    } catch (e) {
      _logger.e('Failed to update or create ticket for event $eventId, ticket ID ${ticket.ticketId}: $e');
      throw Exception('Failed to save ticket: $e');
    }
  }

  // Batch saves multiple tickets to Firestore, ensuring atomicity
  Future<void> saveAllTickets(String eventId, List<Ticket> tickets) async {
    final batch = firestore.batch();

    try {
      for (var ticket in tickets) {
        final ticketRef = firestore.collection('events').doc(eventId).collection('tickets').doc(ticket.ticketId);
        batch.set(ticketRef, TomaTicketMapper.toFirestore(ticket));
      }

      await batch.commit();
      _logger.i('All tickets saved in batch for event ID: $eventId');
    } catch (e) {
      _logger.e('Failed to save all tickets for event $eventId in batch: $e');
      throw Exception('Failed to save all tickets in batch: $e');
    }
  }

  // Fetches all tickets for a specific event, converting each document to a Ticket model
  Future<List<Ticket>> getTickets(String eventId) async {
    try {
      final ticketCollection = await firestore.collection('events').doc(eventId).collection('tickets').get();
      _logger.i('Fetched ${ticketCollection.docs.length} tickets for event ID: $eventId');
      return ticketCollection.docs.map((doc) => TomaTicketMapper.fromFirestore(doc)).toList();
    } catch (e) {
      _logger.e('Failed to fetch tickets for event $eventId: $e');
      throw Exception('Failed to fetch tickets: $e');
    }
  }

  // Deletes a specific ticket document in Firestore
  Future<void> deleteTicket(String eventId, String ticketId) async {
    try {
      await firestore.collection('events').doc(eventId).collection('tickets').doc(ticketId).delete();
      _logger.i('Ticket deleted successfully for event ID: $eventId, ticket ID: $ticketId');
    } catch (e) {
      _logger.e('Failed to delete ticket for event $eventId, ticket ID $ticketId: $e');
      throw Exception('Failed to delete ticket: $e');
    }
  }
}
