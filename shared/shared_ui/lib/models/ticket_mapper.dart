import 'package:cloud_firestore/cloud_firestore.dart';
import 'ticket_model.dart';

class TicketMapper {
  /// Converts a Firestore document to a Ticket model instance
  static Ticket fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle nullable data explicitly
    if (data == null) {
      throw StateError("Missing data for Ticket ID: ${doc.id}");
    }

    return Ticket(
      ticketId: doc.id,
      eventId: data['eventId'] as String,
      ticketType: data['ticketType'] as String,
      ticketName: data['ticketName'] as String,
      ticketPrice: (data['ticketPrice'] as num).toDouble(),
      availableQuantity: data['availableQuantity'] as int? ?? 0,
      soldQuantity: data['soldQuantity'] as int? ?? 0,
      description: data['description'] as String?,
      stripePriceId: data['stripePriceId'] as String?,
      isRefundable: data['isRefundable'] as bool? ?? true,
      ticketSaleStartDateTime: _timestampToDate(data['ticketSaleStartDateTime']),
      ticketSaleEndDateTime: _timestampToDate(data['ticketSaleEndDateTime']),
      isSoldOut: data['isSoldOut'] as bool? ?? false,
    );
  }

  /// Converts a Ticket model instance to a Firestore-compatible JSON map
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
      'ticketSaleStartDateTime': _dateToTimestamp(ticket.ticketSaleStartDateTime),
      'ticketSaleEndDateTime': _dateToTimestamp(ticket.ticketSaleEndDateTime),
      'isSoldOut': ticket.isSoldOut,
    };
  }

  /// Converts Firestore Timestamp to DateTime
  static DateTime? _timestampToDate(dynamic timestamp) {
    return timestamp != null && timestamp is Timestamp ? timestamp.toDate() : null;
  }

  /// Converts DateTime to Firestore Timestamp
  static Timestamp? _dateToTimestamp(DateTime? date) {
    return date != null ? Timestamp.fromDate(date) : null;
  }
}