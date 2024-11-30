import 'package:organizer_app/ticket_scanning/data/data_source/remote_data_source.dart';
import '../../domain/repository/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketRemoteDataSource remoteDataSource;

  TicketRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> validateTicket(String ticketCode) async {
    return await remoteDataSource.validateTicket(ticketCode);
  }
}