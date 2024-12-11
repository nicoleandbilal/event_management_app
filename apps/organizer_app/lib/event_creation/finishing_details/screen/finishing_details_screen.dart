import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/finishing_details/blocs/finishing_details_bloc.dart';
import 'package:organizer_app/event_creation/finishing_details/blocs/finishing_details_event.dart';
import 'package:organizer_app/event_creation/finishing_details/blocs/finishing_details_state.dart';
import 'package:organizer_app/event_creation/finishing_details/models/finishing_details_model.dart';
import 'package:shared/date_and_time_picker/date_and_time_picker.dart';

class FinishingDetailsScreen extends StatelessWidget {
  final String eventId;

  const FinishingDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinishingDetailsBloc, FinishingDetailsState>(
      builder: (context, state) {
        if (state is FinishingDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FinishingDetailsLoaded) {
          return _FinishingDetailsForm(
            eventId: eventId,
            finishingDetails: state.finishingDetails,
          );
        }

        if (state is FinishingDetailsError) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        return const Center(child: Text('Loading finishing details...'));
      },
    );
  }
}

class _FinishingDetailsForm extends StatefulWidget {
  final String eventId;
  final FinishingDetailsModel finishingDetails;

  const _FinishingDetailsForm({
    super.key,
    required this.eventId,
    required this.finishingDetails,
  });

  @override
  State<_FinishingDetailsForm> createState() => _FinishingDetailsFormState();
}

class _FinishingDetailsFormState extends State<_FinishingDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _remarksController;
  DateTime? _salesStartDate;
  TimeOfDay? _salesStartTime;
  DateTime? _salesEndDate;
  TimeOfDay? _salesEndTime;
  bool _privacyPolicyAgreed = false;

  @override
  void initState() {
    super.initState();

    _remarksController =
        TextEditingController(text: widget.finishingDetails.remarks);
    _salesStartDate = widget.finishingDetails.salesStartDate;
    _salesStartTime = widget.finishingDetails.salesStartDate != null
        ? TimeOfDay.fromDateTime(widget.finishingDetails.salesStartDate!)
        : null;
    _salesEndDate = widget.finishingDetails.salesEndDate;
    _salesEndTime = widget.finishingDetails.salesEndDate != null
        ? TimeOfDay.fromDateTime(widget.finishingDetails.salesEndDate!)
        : null;
    _privacyPolicyAgreed = widget.finishingDetails.privacyPolicyAgreed;
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final updatedDetails = FinishingDetailsModel(
        eventId: widget.eventId,
        remarks: _remarksController.text.trim(),
        salesStartDate: _salesStartDate != null && _salesStartTime != null
            ? DateTime(
                _salesStartDate!.year,
                _salesStartDate!.month,
                _salesStartDate!.day,
                _salesStartTime!.hour,
                _salesStartTime!.minute,
              )
            : null,
        salesEndDate: _salesEndDate != null && _salesEndTime != null
            ? DateTime(
                _salesEndDate!.year,
                _salesEndDate!.month,
                _salesEndDate!.day,
                _salesEndTime!.hour,
                _salesEndTime!.minute,
              )
            : null,
        privacyPolicyAgreed: _privacyPolicyAgreed,
      );

      context.read<FinishingDetailsBloc>().add(
            SaveFinishingDetails(updatedDetails),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Remarks
            TextFormField(
              controller: _remarksController,
              decoration: const InputDecoration(
                labelText: 'Remarks',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            // Sales Start Date & Time
            CreateEventDatePicker(
              label: 'Sales Start Date & Time',
              date: _salesStartDate,
              time: _salesStartTime,
              onDatePicked: (date) => setState(() => _salesStartDate = date),
              onTimePicked: (time) => setState(() => _salesStartTime = time),
            ),
            const SizedBox(height: 20),

            // Sales End Date & Time
            CreateEventDatePicker(
              label: 'Sales End Date & Time',
              date: _salesEndDate,
              time: _salesEndTime,
              onDatePicked: (date) => setState(() => _salesEndDate = date),
              onTimePicked: (time) => setState(() => _salesEndTime = time),
            ),
            const SizedBox(height: 20),

            // Privacy Policy Checkbox
            CheckboxListTile(
              value: _privacyPolicyAgreed,
              title: const Text("I agree to the privacy policy"),
              onChanged: (value) => setState(() => _privacyPolicyAgreed = value ?? false),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}