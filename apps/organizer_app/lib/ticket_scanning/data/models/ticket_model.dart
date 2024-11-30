import '../../domain/entities/ticket.dart';

class TicketModel extends Ticket {
  TicketModel({
    required String code,
    required String eventId,
    required bool isScanned,
  }) : super(code: code, eventId: eventId, isScanned: isScanned);

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      code: json['code'],
      eventId: json['eventId'],
      isScanned: json['isScanned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'eventId': eventId,
      'isScanned': isScanned,
    };
  }
}