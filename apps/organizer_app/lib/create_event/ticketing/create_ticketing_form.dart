// create_ticketing_form.dart

import 'package:flutter/material.dart';
import 'package:shared/widgets/custom_input_box.dart';

class CreateTicketForm extends StatelessWidget {
  final String eventId;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();
  final TextEditingController _ticketQuantityController = TextEditingController();
  final TextEditingController _saleStartDateController = TextEditingController();
  final TextEditingController _saleEndDateController = TextEditingController();
  bool _isPaidTicket = true;

  // Constructor with required eventId parameter
  CreateTicketForm({
    super.key,
    required this.eventId,
  });

  Map<String, dynamic> getFormData() {
    return {
      'ticketName': _ticketNameController.text,
      'ticketPrice': _isPaidTicket ? double.tryParse(_ticketPriceController.text) ?? 0.0 : 0.0,
      'ticketQuantity': int.tryParse(_ticketQuantityController.text) ?? 0,
      'saleStartDate': DateTime.tryParse(_saleStartDateController.text),
      'saleEndDate': DateTime.tryParse(_saleEndDateController.text),
      'isPaidTicket': _isPaidTicket,
    };
  }

  bool validateForm() {
    return _formKey.currentState?.validate() == true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ticket Options',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Divider(height: 1, color: Colors.grey),

          const SizedBox(height: 20),

          _buildTicketTypeToggle(),
          _buildTextInput(
            label: 'Ticket Name',
            placeholder: 'Enter ticket name',
            controller: _ticketNameController,
            validator: (value) => value?.isEmpty == true ? 'Please enter ticket name' : null,
          ),
          const SizedBox(height: 16),
          if (_isPaidTicket)
            _buildTextInput(
              label: 'Ticket Price',
              placeholder: 'Enter ticket price',
              controller: _ticketPriceController,
              validator: (value) => value == null || value.isEmpty ? 'Please enter ticket price' : null,
            ),
          const SizedBox(height: 16),
          _buildTextInput(
            label: 'Quantity',
            placeholder: 'Enter quantity available',
            controller: _ticketQuantityController,
            validator: (value) => value?.isEmpty == true ? 'Please enter quantity' : null,
          ),
          const SizedBox(height: 16),
          _buildTextInput(
            label: 'Sale Start Date',
            placeholder: 'Enter sale start date (YYYY-MM-DD)',
            controller: _saleStartDateController,
            validator: (value) => value?.isEmpty == true ? 'Please enter sale start date' : null,
          ),
          const SizedBox(height: 16),
          _buildTextInput(
            label: 'Sale End Date',
            placeholder: 'Enter sale end date (YYYY-MM-DD)',
            controller: _saleEndDateController,
            validator: (value) => value?.isEmpty == true ? 'Please enter sale end date' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTicketTypeToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Free Ticket'),
        Switch(
          value: _isPaidTicket,
          onChanged: (value) => _isPaidTicket = value,
        ),
        const Text('Paid Ticket'),
      ],
    );
  }

  Widget _buildTextInput({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        CustomInputBox(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
