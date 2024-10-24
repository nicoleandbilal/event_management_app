// ticket_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String ticketId;
  final String eventId; // Foreign key to relate to the Event
  final String ticketType; // e.g., VIP, General Admission, Early Bird
  final String description; // Description of this ticket type
  final double price; // Price of this ticket type
  final int availableQuantity; // Total tickets available of this type
  final int soldQuantity; // Total tickets sold of this type
  final String? stripePriceId; // Stripe Price ID for this specific ticket type (if integrated with Stripe)
  final bool isRefundable; // Indicates if the ticket is refundable
  final DateTime? saleStartDate; // When sales for this ticket type start
  final DateTime? saleEndDate; // When sales for this ticket type end
  final bool isSoldOut; // If tickets are sold out

  Ticket({
    required this.ticketId,
    required this.eventId,
    required this.ticketType,
    required this.description,
    required this.price,
    required this.availableQuantity,
    required this.soldQuantity,
    this.stripePriceId,
    this.isRefundable = true, // Default to true, but can be set to false if needed
    this.saleStartDate,
    this.saleEndDate,
    this.isSoldOut = false, // By default, tickets are not sold out
  });

  // Convert Firestore document to Ticket model
  factory Ticket.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ticket(
      ticketId: doc.id,
      eventId: data['eventId'],
      ticketType: data['ticketType'],
      description: data['description'],
      price: data['price'].toDouble(),
      availableQuantity: data['availableQuantity'],
      soldQuantity: data['soldQuantity'] ?? 0, // Default to 0 if not available
      stripePriceId: data['stripePriceId'],
      isRefundable: data['isRefundable'] ?? true,
      saleStartDate: data['saleStartDate'] != null
          ? (data['saleStartDate'] as Timestamp).toDate()
          : null,
      saleEndDate: data['saleEndDate'] != null
          ? (data['saleEndDate'] as Timestamp).toDate()
          : null,
      isSoldOut: data['isSoldOut'] ?? false,
    );
  }

  // Convert Ticket model to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'ticketType': ticketType,
      'description': description,
      'price': price,
      'availableQuantity': availableQuantity,
      'soldQuantity': soldQuantity,
      'stripePriceId': stripePriceId,
      'isRefundable': isRefundable,
      'saleStartDate': saleStartDate != null
          ? Timestamp.fromDate(saleStartDate!)
          : null,
      'saleEndDate': saleEndDate != null
          ? Timestamp.fromDate(saleEndDate!)
          : null,
      'isSoldOut': isSoldOut,
    };
  }
}
