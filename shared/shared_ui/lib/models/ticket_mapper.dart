// ticket_mapper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'ticket_model.dart';

class TomaTicketMapper {
  // Converts Firestore document to a Ticket model instance
  static Ticket fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Explicitly handle nullable data
    if (data == null) {
      throw StateError("Missing data for Ticket ID: ${doc.id}");
    }

    return Ticket(
      ticketId: doc.id,
      eventId: data['eventId'] as String,
      ticketType: data['ticketType'] as String,
      ticketName: data['ticketName'] as String,
      ticketPrice: (data['ticketPrice'] as num).toDouble(), // Ensure type safety for double
      availableQuantity: data['availableQuantity'] as int,
      soldQuantity: data['soldQuantity'] as int,
      description: data['description'] as String?,
      stripePriceId: data['stripePriceId'] as String?,
      isRefundable: data['isRefundable'] as bool? ?? true,
      ticketSaleStartDateTime: data['ticketSaleStartDateTime'] != null
          ? (data['ticketSaleStartDateTime'] as Timestamp).toDate()
          : null,
      ticketSaleEndDateTime: data['ticketSaleEndDateTime'] != null
          ? (data['ticketSaleEndDateTime'] as Timestamp).toDate()
          : null,
      isSoldOut: data['isSoldOut'] as bool? ?? false,
    );
  }

  // Converts a Ticket model instance to Firestore-compatible JSON map
  static Map<String, dynamic> toFirestore(Ticket ticket) {
    return {
      'eventId': ticket.eventId,
      'ticketType': ticket.ticketType,
      'ticketName': ticket.ticketName,
      'ticketPrice': ticket.ticketPrice,
      'availableQuantity': ticket.availableQuantity,
      'soldQuantity': ticket.soldQuantity,
      'description': ticket.description,
      'stripePriceId': ticket.stripePriceId,
      'isRefundable': ticket.isRefundable,
      'ticketSaleStartDateTime': ticket.ticketSaleStartDateTime != null
          ? Timestamp.fromDate(ticket.ticketSaleStartDateTime!)
          : null,
      'ticketSaleEndDateTime': ticket.ticketSaleEndDateTime != null
          ? Timestamp.fromDate(ticket.ticketSaleEndDateTime!)
          : null,
      'isSoldOut': ticket.isSoldOut,
    };
  }
}
