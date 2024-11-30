import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/ticket_scanning/domain/use_cases/validate_ticket_use_case.dart';
import 'ticket_scan_event.dart';
import 'ticket_scan_state.dart';

class TicketScanBloc extends Bloc<TicketScanEvent, TicketScanState> {
  final ValidateTicketUseCase validateTicketUseCase;

  TicketScanBloc({required this.validateTicketUseCase}) : super(TicketScanInitial()) {
    on<ScanTicket>(_onScanTicket);
    on<SyncTickets>(_onSyncTickets);
  }

  Future<void> _onScanTicket(ScanTicket event, Emitter<TicketScanState> emit) async {
    emit(TicketScanLoading());
    try {
      final isValid = await validateTicketUseCase(event.ticketCode);

      if (isValid) {
        emit(TicketValid(event.ticketCode));
      } else {
        emit(const TicketInvalid("This ticket is invalid."));
      }
    } catch (e) {
      emit(TicketScanError(e.toString()));
    }
  }

  Future<void> _onSyncTickets(SyncTickets event, Emitter<TicketScanState> emit) async {
    // Placeholder for syncing logic if offline support is implemented.
  }
}