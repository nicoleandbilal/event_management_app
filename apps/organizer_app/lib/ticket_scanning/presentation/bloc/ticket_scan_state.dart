import 'package:equatable/equatable.dart';

abstract class TicketScanState extends Equatable {
  const TicketScanState();

  @override
  List<Object?> get props => [];
}

class TicketScanInitial extends TicketScanState {}

class TicketScanLoading extends TicketScanState {}

class TicketValid extends TicketScanState {
  final String ticketCode;

  const TicketValid(this.ticketCode);

  @override
  List<Object?> get props => [ticketCode];
}

class TicketInvalid extends TicketScanState {
  final String reason;

  const TicketInvalid(this.reason);

  @override
  List<Object?> get props => [reason];
}

class TicketScanError extends TicketScanState {
  final String message;

  const TicketScanError(this.message);

  @override
  List<Object?> get props => [message];
}