import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/ticket_mapper.dart';
import '../models/ticket_model.dart';

class TicketRepository {
  final FirebaseFirestore _firestore;
  final Logger _logger = Logger();

  TicketRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  /// Utility to get the tickets collection reference
  CollectionReference<Map<String, dynamic>> _ticketsCollection(String eventId) {
    return _firestore.collection('events').doc(eventId).collection('tickets');
  }

  /// Creates a draft ticket and returns the generated ticket ID
  Future<String> createDraftTicket(String eventId, Ticket ticket) async {
    try {
      final ticketRef = _ticketsCollection(eventId).doc(); // Generate a new document ID
      await ticketRef.set(TicketMapper.toFirestore(ticket));
      _logger.i('Draft ticket created: Event ID=$eventId, Ticket ID=${ticketRef.id}');
      return ticketRef.id;
    } catch (e) {
      _logger.e('Error creating draft ticket: Event ID=$eventId, Error=$e');
      throw Exception('Failed to create draft ticket.');
    }
  }

  /// Updates an existing draft ticket or creates it if it doesn't exist
  Future<void> updateDraftTicket(String eventId, Ticket ticket) async {
    try {
      final ticketRef = _ticketsCollection(eventId).doc(ticket.ticketId);
      await ticketRef.set(TicketMapper.toFirestore(ticket));
      _logger.i('Ticket updated: Event ID=$eventId, Ticket ID=${ticket.ticketId}');
    } catch (e) {
      _logger.e('Error updating ticket: Event ID=$eventId, Ticket ID=${ticket.ticketId}, Error=$e');
      throw Exception('Failed to update ticket.');
    }
  }

  /// Saves all tickets for an event in a batch operation
  Future<void> saveAllTickets(String eventId, List<Ticket> tickets) async {
    final batch = _firestore.batch();
    try {
      for (final ticket in tickets) {
        final ticketRef = _ticketsCollection(eventId).doc(ticket.ticketId);
        batch.set(ticketRef, TicketMapper.toFirestore(ticket));
      }
      await batch.commit();
      _logger.i('All tickets saved: Event ID=$eventId, Count=${tickets.length}');
    } catch (e) {
      _logger.e('Error saving tickets: Event ID=$eventId, Error=$e');
      throw Exception('Failed to save tickets.');
    }
  }

  /// Fetches all tickets for a specific event
  Future<List<Ticket>> getTickets(String eventId) async {
    try {
      final querySnapshot = await _ticketsCollection(eventId).get();
      _logger.i('Fetched tickets: Event ID=$eventId, Count=${querySnapshot.docs.length}');
      return querySnapshot.docs
          .map((doc) => TicketMapper.fromFirestore(doc))
          .toList();
    } catch (e) {
      _logger.e('Error fetching tickets: Event ID=$eventId, Error=$e');
      throw Exception('Failed to fetch tickets.');
    }
  }

  /// Deletes a specific ticket by ID
  Future<void> deleteTicket(String eventId, String ticketId) async {
    try {
      await _ticketsCollection(eventId).doc(ticketId).delete();
      _logger.i('Ticket deleted: Event ID=$eventId, Ticket ID=$ticketId');
    } catch (e) {
      _logger.e('Error deleting ticket: Event ID=$eventId, Ticket ID=$ticketId, Error=$e');
      throw Exception('Failed to delete ticket.');
    }
  }
}