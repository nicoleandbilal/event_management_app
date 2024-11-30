import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_event.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_state.dart';
import 'package:shared/models/ticket_model.dart';

class AddTicketModal extends StatefulWidget {
  final String eventId;

  const AddTicketModal({super.key, required this.eventId});

  @override
  _AddTicketModalState createState() => _AddTicketModalState();
}

class _AddTicketModalState extends State<AddTicketModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();
  final TextEditingController _availableQuantityController = TextEditingController();

  @override
  void dispose() {
    _ticketNameController.dispose();
    _ticketPriceController.dispose();
    _availableQuantityController.dispose();
    super.dispose();
  }

  void _saveTicket(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bloc = context.read<TicketDetailsBloc>();

    final ticket = Ticket(
      ticketId: '', // Will be generated in the backend
      eventId: widget.eventId,
      ticketType: 'Paid', // Default type, can be extended
      ticketName: _ticketNameController.text.trim(),
      ticketPrice: double.parse(_ticketPriceController.text),
      availableQuantity: int.parse(_availableQuantityController.text),
      soldQuantity: 0,
      isRefundable: true,
      isSoldOut: false,
    );

    bloc.add(AddTicketToEvent(eventId: widget.eventId, ticket: ticket));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: BlocConsumer<TicketDetailsBloc, TicketDetailsState>(
        listener: (context, state) {
          if (state is TicketDetailsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          if (state is TicketListUpdated) {
            Navigator.pop(context); // Close modal on successful save
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Add Ticket',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ticketNameController,
                    decoration: const InputDecoration(labelText: 'Ticket Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ticket name is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _ticketPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Ticket Price'),
                    validator: (value) {
                      final price = double.tryParse(value ?? '');
                      if (price == null || price < 0) {
                        return 'Enter a valid ticket price.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _availableQuantityController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Available Quantity'),
                    validator: (value) {
                      final quantity = int.tryParse(value ?? '');
                      if (quantity == null || quantity < 0) {
                        return 'Enter a valid quantity.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _saveTicket(context),
                    child: const Text('Save Ticket'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}