import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/blocs/basic_details_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/blocs/basic_details_event.dart';
import 'package:organizer_app/event_creation/basic_details/blocs/basic_details_state.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/event_image_uploader_widget.dart';
import 'package:organizer_app/event_creation/basic_details/models/basic_details_model.dart';
import 'package:shared/date_and_time_picker/date_and_time_picker.dart';

class BasicDetailsScreen extends StatelessWidget {
  final String eventId;

  const BasicDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasicDetailsBloc, BasicDetailsState>(
      builder: (context, state) {
        if (state is BasicDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BasicDetailsLoaded) {
          return _BasicDetailsForm(eventId: eventId, basicDetails: state.basicDetails);
        }

        if (state is BasicDetailsError) {
          return Center(child: Text(state.errorMessage));
        }

        return const Center(child: Text('Loading event details...'));
      },
    );
  }
}

class _BasicDetailsForm extends StatefulWidget {
  final String eventId;
  final BasicDetailsModel basicDetails;

  const _BasicDetailsForm({super.key, required this.eventId, required this.basicDetails});

  @override
  State<_BasicDetailsForm> createState() => _BasicDetailsFormState();
}

class _BasicDetailsFormState extends State<_BasicDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _eventNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late DateTime? _startDate;
  late TimeOfDay? _startTime;
  late DateTime? _endDate;
  late TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();

    _eventNameController = TextEditingController(text: widget.basicDetails.eventName);
    _descriptionController = TextEditingController(text: widget.basicDetails.description);
    _categoryController = TextEditingController(text: widget.basicDetails.category);
    _startDate = widget.basicDetails.startDateTime;
    _startTime = TimeOfDay.fromDateTime(widget.basicDetails.startDateTime);
    _endDate = widget.basicDetails.endDateTime;
    _endTime = TimeOfDay.fromDateTime(widget.basicDetails.endDateTime);
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

// Simplified snippet showing corrected `_onSave` usage.
void _onSave() {
  if (_formKey.currentState!.validate()) {
    final updatedDetails = BasicDetailsModel(
      eventId: widget.eventId,
      eventName: _eventNameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      venue: widget.basicDetails.venue,
      startDateTime: DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      ),
      endDateTime: DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      ),
    );

    context.read<BasicDetailsBloc>().add(SaveBasicDetails(updatedDetails));
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
            // Image Upload
            ImageUploaderWidget(eventId: widget.eventId),
            const SizedBox(height: 20),

            // Event Name
            TextFormField(
              controller: _eventNameController,
              decoration: const InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Event Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Category
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Category is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Start Date & Time
            CreateEventDatePicker(
              label: 'Start Date & Time',
              date: _startDate,
              time: _startTime,
              onDatePicked: (date) => setState(() => _startDate = date),
              onTimePicked: (time) => setState(() => _startTime = time),
            ),
            const SizedBox(height: 20),

            // End Date & Time
            CreateEventDatePicker(
              label: 'End Date & Time',
              date: _endDate,
              time: _endTime,
              onDatePicked: (date) => setState(() => _endDate = date),
              onTimePicked: (time) => setState(() => _endTime = time),
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