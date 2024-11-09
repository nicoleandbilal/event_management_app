import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_model.freezed.dart';
part 'ticket_model.g.dart';

@freezed
class Ticket with _$Ticket {
  const factory Ticket({
    required String ticketId,
    required String eventId,
    required String ticketName,
    required double ticketPrice,
    required int availableQuantity,
    required int soldQuantity,
    String? description,
    String? stripePriceId,
    @Default(true) bool isRefundable,
    DateTime? saleStartDate,
    DateTime? saleEndDate,
    @Default(false) bool isSoldOut,
  }) = _Ticket;

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);
}
