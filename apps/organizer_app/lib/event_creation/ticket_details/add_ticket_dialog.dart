// add_ticket_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_bloc.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_event.dart';
import 'package:organizer_app/event_creation/ticket_details/bloc/ticket_details_state.dart';
import 'package:organizer_app/event_creation/ticket_details/ticket_dialog_cubit.dart';
import 'package:shared/models/ticket_model.dart';
import 'package:shared/widgets/custom_label_input_box.dart';

class AddTicketDialog extends StatefulWidget {
  final String eventId;

  const AddTicketDialog({super.key, required this.eventId});

  @override
  AddTicketDialogState createState() => AddTicketDialogState();
}

class AddTicketDialogState extends State<AddTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();
  final TextEditingController _availableQuantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final bool _isRefundable = true;

  @override
  void dispose() {
    _ticketNameController.dispose();
    _ticketPriceController.dispose();
    _availableQuantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Ticket getTicketData() {
    return Ticket(
      ticketId: '', // Generated after saving
      eventId: widget.eventId,
      ticketType: 'Paid',
      ticketName: _ticketNameController.text,
      ticketPrice: double.tryParse(_ticketPriceController.text) ?? 0.0,
      availableQuantity: int.tryParse(_availableQuantityController.text) ?? 0,
      soldQuantity: 0,
      description: _descriptionController.text,
      isRefundable: _isRefundable,
      isSoldOut: false,
    );
  }

  void _onSavePressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final ticket = getTicketData();
      context.read<TicketDetailsBloc>().add(SaveTicketDetailsEvent(ticket: ticket));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields correctly')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TicketFormCubit(),
      child: BlocConsumer<TicketDetailsBloc, TicketDetailsState>(
        listener: (context, state) {
          if (state is TicketDetailsSaved) {
            Navigator.of(context).pop();
          } else if (state is TicketDetailsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
            child: Container(
              constraints: const BoxConstraints(minHeight: 500, minWidth: 300),
              padding: const EdgeInsets.all(26.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Ticket Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomLabelInputBox(
                          labelText: 'Ticket Name',
                          controller: _ticketNameController,
                          validationMessage: _ticketNameController.text.isEmpty ? 'Please enter a ticket name' : '',
                        ),
                        const SizedBox(height: 16),
                        CustomLabelInputBox(
                          labelText: 'Ticket Description',
                          controller: _descriptionController,
                          validationMessage: _descriptionController.text.isEmpty ? 'Enter a description' : '',
                        ),
                        const SizedBox(height: 16),
                        CustomLabelInputBox(
                          labelText: 'Ticket Price',
                          controller: _ticketPriceController,
                          validationMessage: double.tryParse(_ticketPriceController.text) == null
                              ? 'Please enter a valid price'
                              : '',
                        ),
                        const SizedBox(height: 16),
                        CustomLabelInputBox(
                          labelText: 'Available Quantity',
                          controller: _availableQuantityController,
                          validationMessage: int.tryParse(_availableQuantityController.text) == null
                              ? 'Please enter a valid quantity'
                              : '',
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade800),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => _onSavePressed(context),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: state is TicketDetailsLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text('Save'),
                      ),
                    ],
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
