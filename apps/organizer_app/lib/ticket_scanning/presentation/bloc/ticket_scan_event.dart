import 'package:equatable/equatable.dart';

abstract class TicketScanEvent extends Equatable {
  const TicketScanEvent();

  @override
  List<Object?> get props => [];
}

class ScanTicket extends TicketScanEvent {
  final String ticketCode;

  const ScanTicket(this.ticketCode);

  @override
  List<Object?> get props => [ticketCode];
}

class SyncTickets extends TicketScanEvent {
  const SyncTickets();
}