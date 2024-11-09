// create_event_details_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared/widgets/date_and_time_picker.dart';
import 'package:organizer_app/create_event/event_cover_image/create_event_image_upload.dart';
import 'package:shared/widgets/custom_input_box.dart';

class CreateEventDetailsForm extends StatelessWidget {
  final String brandId;
  final String eventId;

  static final _formKey = GlobalKey<FormState>();

  static final TextEditingController _eventNameController = TextEditingController();
  static final TextEditingController _descriptionController = TextEditingController();
  static final TextEditingController _venueController = TextEditingController();
  static DateTime? _startDate;
  static TimeOfDay? _startTime;
  static DateTime? _endDate;
  static TimeOfDay? _endTime;
  static String? _selectedCategory;

  // Constructor with required parameters
  const CreateEventDetailsForm({
    super.key,
    required this.brandId,
    required this.eventId,
  });

  // Collect form data for Bloc dispatch in the main screen
  static Map<String, dynamic> collectFormData() {
    final startDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    final endDateTime = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    return {
      'eventName': _eventNameController.text,
      'description': _descriptionController.text,
      'category': _selectedCategory ?? 'Other',
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'venue': _venueController.text,
    };
  }

  bool _validateForm() {
    return _formKey.currentState?.validate() == true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Event Details',
              style: GoogleFonts.raleway(
                fontSize: 24.0, 
                fontWeight: FontWeight.bold),
            ),

                const SizedBox(height: 10),

                const Divider(height: 1, color: Colors.grey),

                const SizedBox(height: 20),

            _buildTextInput(
              label: 'Event Name',
              placeholder: 'Enter event name',
              controller: _eventNameController,
              validator: (value) => value?.isEmpty == true ? 'Please enter event name' : null,
            ),
            const SizedBox(height: 16),

            CreateEventImageUpload(imageUploadService: context.read(), eventId: eventId), // Use eventId here

            const SizedBox(height: 16),

            _buildTextInput(
              label: 'Event Description',
              placeholder: 'Enter event description',
              controller: _descriptionController,
              validator: (value) => value?.isEmpty == true ? 'Please enter event description' : null,
            ),

            const SizedBox(height: 16),

            CreateEventDatePicker(
              label: "Start",
              date: _startDate,
              time: _startTime,
              onDatePicked: (pickedDate) => _startDate = pickedDate,
              onTimePicked: (pickedTime) => _startTime = pickedTime,
            ),

            const SizedBox(height: 16),

            CreateEventDatePicker(
              label: "End",
              date: _endDate,
              time: _endTime,
              onDatePicked: (pickedDate) => _endDate = pickedDate,
              onTimePicked: (pickedTime) => _endTime = pickedTime,
            ),

            const SizedBox(height: 16),

            _buildCategoryDropdown(),

            const SizedBox(height: 16),

            _buildTextInput(
              label: 'Choose Venue',
              placeholder: 'Enter venue',
              controller: _venueController,
              validator: (value) => value?.isEmpty == true ? 'Please enter venue' : null,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
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
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        CustomInputBox(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: placeholder,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w300, 
                color: Colors.black),
              border: InputBorder.none,),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        CustomInputBox(
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: <String>['Conference', 'Workshop', 'Meetup', 'Seminar', 'Other']
                .map((String value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (newValue) => _selectedCategory = newValue,
            decoration: const InputDecoration(border: InputBorder.none),
            validator: (value) => value?.isEmpty == true ? 'Please select a category' : null,
          ),
        ),
      ],
    );
  }
}
