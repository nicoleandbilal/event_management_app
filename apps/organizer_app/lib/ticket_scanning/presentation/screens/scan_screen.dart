import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/ticket_scanning/data/data_source/remote_data_source.dart';
import 'package:organizer_app/ticket_scanning/data/repository/ticket_repository_impl.dart';
import 'package:organizer_app/ticket_scanning/domain/use_cases/validate_ticket_use_case.dart';
import 'package:organizer_app/ticket_scanning/presentation/bloc/ticket_scan_bloc.dart';
import 'package:organizer_app/ticket_scanning/presentation/bloc/ticket_scan_event.dart';
import 'package:organizer_app/ticket_scanning/presentation/bloc/ticket_scan_state.dart';
import 'package:organizer_app/ticket_scanning/presentation/widgets/qr_scanner_widget.dart';
import 'package:shared/widgets/loading_widget.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create local dependencies
    final firestore = FirebaseFirestore.instance;
    final remoteDataSource = TicketRemoteDataSource(firestore: firestore);
    final ticketRepository = TicketRepositoryImpl(remoteDataSource: remoteDataSource);
    final validateTicketUseCase = ValidateTicketUseCase(ticketRepository);
    
    return BlocProvider(
      create: (_) => TicketScanBloc(validateTicketUseCase: validateTicketUseCase),
      child: BlocConsumer<TicketScanBloc, TicketScanState>(
        listener: (context, state) {
          if (state is TicketValid) {
            _showSnackbar(context, 'Ticket is valid!');
          } else if (state is TicketInvalid) {
            _showSnackbar(context, 'Ticket is invalid: ${state.reason}');
          } else if (state is TicketScanError) {
            _showSnackbar(context, 'Error: ${state.message}');
          }
        },
        builder: (context, state) {
          if (state is TicketScanLoading) {
            return const Center(child: LoadingWidget());
          } else {
            return QRScannerWidget(
              onScan: (code) {
                BlocProvider.of<TicketScanBloc>(context).add(ScanTicket(code));
              },
            );
          }
        },
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}