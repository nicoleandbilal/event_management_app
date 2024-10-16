// create_event_form.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/blocs/create_event/create_event_form_bloc.dart';
import 'package:organizer_app/blocs/create_event/create_event_form_event.dart';
import 'package:organizer_app/models/create_event_model.dart';
import 'package:organizer_app/widgets/create_event_date_picker.dart';
import 'package:organizer_app/widgets/create_event_image_upload.dart';
import 'package:organizer_app/widgets/input_box.dart';
import 'package:go_router/go_router.dart';

class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  void _createEvent(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null ||
          _startTime == null ||
          _endDate == null ||
          _endTime == null) {
        _showErrorDialog('Please select both start and end date/time');
        return;
      }

      DateTime startDateTime = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );

      DateTime endDateTime = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );

      if (endDateTime.isBefore(startDateTime)) {
        _showErrorDialog('End date/time must be after start date/time');
        return;
      }

      context.read<CreateEventFormBloc>().add(
            SubmitCreateEventForm(
              CreateEvent(
                eventName: _eventNameController.text,
                description: _descriptionController.text,
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                category: _categoryController.text,
                venue: _venueController.text,
                imageUrl: _urlController.text,
              ),
            ),
          );
    }
  }

  void _showErrorDialog(String message) {
    // Navigate to the error dialog route using GoRouter
    context.push(
      '/error',
      extra: {'message': message},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextInput(
              'Event Name',
              'Enter event name',
              _eventNameController,
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter event name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CreateEventImageUpload(urlController: _urlController),
            const SizedBox(height: 16),
            _buildTextInput(
              'Event Description',
              'Enter event description',
              _descriptionController,
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter event description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CreateEventDatePicker(
              label: "Start",
              date: _startDate,
              time: _startTime,
              onDatePicked: (pickedDate) {
                setState(() => _startDate = pickedDate);
              },
              onTimePicked: (pickedTime) {
                setState(() => _startTime = pickedTime);
              },
            ),
            const SizedBox(height: 16),
            CreateEventDatePicker(
              label: "End",
              date: _endDate,
              time: _endTime,
              onDatePicked: (pickedDate) {
                setState(() => _endDate = pickedDate);
              },
              onTimePicked: (pickedTime) {
                setState(() => _endTime = pickedTime);
              },
            ),
            const SizedBox(height: 16),
            _buildTextInput(
              'Choose Category',
              'Enter Category',
              _categoryController,
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter category name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextInput(
              'Choose Venue',
              'Enter Venue',
              _venueController,
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter venue name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => _createEvent(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.grey.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Create Event',
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput(
    String label,
    String placeholder,
    TextEditingController controller,
    String? Function(String?) validator,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 8),
        InputBox(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w300,
                color: Theme.of(context).colorScheme.primary,
              ),
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
