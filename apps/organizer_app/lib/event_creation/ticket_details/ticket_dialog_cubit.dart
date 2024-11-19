// ticket_dialog_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/models/ticket_model.dart';

class TicketFormCubit extends Cubit<Ticket?> {
  TicketFormCubit() : super(null);

  void updateTicketDetails(Ticket ticket) => emit(ticket);

  // Additional form validation logic
  bool isFormValid(Ticket ticket) {
    return ticket.ticketName.isNotEmpty &&
           ticket.ticketPrice > 0 &&
           ticket.availableQuantity >= 0;
  }

  String? validateField(String field, dynamic value) {
    switch (field) {
      case 'ticketName':
        return value.isEmpty ? 'Please enter a ticket name' : null;
      case 'ticketPrice':
        return value <= 0 ? 'Enter a valid ticket price' : null;
      case 'availableQuantity':
        return value < 0 ? 'Enter a valid quantity' : null;
      default:
        return null;
    }
  }
}
