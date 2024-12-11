import 'package:shared/repositories/ticket_repository.dart';
import 'package:shared/models/ticket_model.dart';
import 'package:logger/logger.dart';

class TicketDetailsService {
  final TicketRepository ticketRepository;
  final Logger logger;

  TicketDetailsService({
    required this.ticketRepository,
    required this.logger,
  });

  /// Saves tickets for a specific event
  Future<void> saveTickets(String eventId, List<Map<String, dynamic>> tickets) async {
    try {
      logger.i("Saving tickets for event ID: $eventId");

      // Convert the list of maps into a list of Ticket model objects
      final ticketModels = tickets.map((data) => Ticket.fromJson(data)).toList();

      // Save tickets to the database using the repository
      await ticketRepository.saveAllTickets(eventId, ticketModels);

      logger.i("Tickets saved successfully for event ID: $eventId");
    } catch (e) {
      logger.e("Failed to save tickets for event ID: $eventId. Error: $e");
      throw Exception("Failed to save tickets.");
    }
  }

  /// Fetches all tickets for a specific event
  Future<List<Ticket>> getTickets(String eventId) async {
    try {
      logger.i("Fetching tickets for event ID: $eventId");
      return await ticketRepository.getTickets(eventId);
    } catch (e) {
      logger.e("Error fetching tickets for event ID $eventId: $e");
      throw Exception("Failed to fetch tickets.");
    }
  }

  /// Adds a single ticket to the event
  Future<void> addTicket(String eventId, Ticket ticket) async {
    try {
      logger.i("Adding ticket to event ID: $eventId");
      await ticketRepository.createDraftTicket(eventId, ticket);
      logger.i("Ticket added successfully for event ID: $eventId");
    } catch (e) {
      logger.e("Error adding ticket to event ID $eventId: $e");
      throw Exception("Failed to add ticket.");
    }
  }

  /// Deletes a specific ticket from an event
  Future<void> deleteTicket(String eventId, String ticketId) async {
    try {
      logger.i("Deleting ticket ID $ticketId from event ID: $eventId");
      await ticketRepository.deleteTicket(eventId, ticketId);
      logger.i("Ticket deleted successfully for event ID: $eventId");
    } catch (e) {
      logger.e("Error deleting ticket ID $ticketId: $e");
      throw Exception("Failed to delete ticket.");
    }
  }

  /// Finalizes tickets for the event, ensuring there is at least one valid ticket
  Future<void> finalizeTickets(String eventId) async {
    try {
      logger.i("Finalizing tickets for event ID: $eventId");

      final tickets = await ticketRepository.getTickets(eventId);
      if (tickets.isEmpty) {
        throw Exception("At least one ticket is required for publishing.");
      }

      logger.i("Tickets finalized successfully for event ID: $eventId");
    } catch (e) {
      logger.e("Error finalizing tickets for event ID: $eventId. Error: $e");
      throw Exception("Failed to finalize tickets.");
    }
  }
}