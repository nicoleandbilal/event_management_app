import '../repository/ticket_repository.dart';

class ValidateTicketUseCase {
  final TicketRepository repository;

  ValidateTicketUseCase(this.repository);

  Future<bool> call(String ticketCode) async {
    return await repository.validateTicket(ticketCode);
  }
}