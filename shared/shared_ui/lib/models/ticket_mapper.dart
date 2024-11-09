// ticket_mapper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'ticket_model.dart';

class TicketMapper {
  static Ticket fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ticket.fromJson({
      'ticketId': doc.id,
      ...data,
      'saleStartDate': data['saleStartDate'] != null ? (data['saleStartDate'] as Timestamp).toDate() : null,
      'saleEndDate': data['saleEndDate'] != null ? (data['saleEndDate'] as Timestamp).toDate() : null,
    });
  }

  static Map<String, dynamic> toFirestore(Ticket ticket) {
    final json = ticket.toJson();
    return {
      ...json,
      'saleStartDate': ticket.saleStartDate != null ? Timestamp.fromDate(ticket.saleStartDate!) : null,
      'saleEndDate': ticket.saleEndDate != null ? Timestamp.fromDate(ticket.saleEndDate!) : null,
    };
  }
}
