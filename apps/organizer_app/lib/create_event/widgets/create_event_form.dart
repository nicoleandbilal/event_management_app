import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_bloc.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_event.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_state.dart';
import 'package:shared/widgets/date_and_time_picker.dart';
import 'package:organizer_app/create_event/widgets/create_event_image_upload.dart';
import 'package:shared/models/event_model.dart';
import 'package:shared/widgets/custom_input_box.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  String? _selectedCategory;

  void _createEvent(BuildContext context, String? fullImageUrl, String? croppedImageUrl) {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _startTime == null || _endDate == null || _endTime == null) {
        _showErrorDialog('Please select both start and end date/time');
        return;
      }

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

      if (endDateTime.isBefore(startDateTime)) {
        _showErrorDialog('End date/time must be after start date/time');
        return;
      }

      final newEvent = Event(
        eventId: '',
        brandId: 'some_brand_id',  // Replace with actual brand ID if needed
        eventName: _eventNameController.text,
        description: _descriptionController.text,
        category: _selectedCategory ?? 'Other',
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        venue: _venueController.text,
        eventCoverImageFullUrl: fullImageUrl,
        eventCoverImageCroppedUrl: croppedImageUrl,
        status: 'draft',
        createdAt: Timestamp.now(),
        updatedAt: null,
        saleStartDate: null,
        saleEndDate: null,
      );

      context.read<CreateEventFormBloc>().add(SubmitCreateEventForm(newEvent));
    }
  }

  void _showErrorDialog(String message) {
    context.push(
      '/error',
      extra: {'message': message},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventFormBloc, CreateEventFormState>(
      builder: (context, state) {
        String? fullImageUrl;
        String? croppedImageUrl;

        // Update image URLs from the state if available
        if (state is CreateEventFormImageUrlsUpdated) {
          fullImageUrl = state.fullImageUrl;
          croppedImageUrl = state.croppedImageUrl;
        }

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
                  (value) => value == null || value.isEmpty ? 'Please enter event name' : null,
                ),
                const SizedBox(height: 16),

                // Image upload widget
                CreateEventImageUpload(imageUploadService: context.read()),

                const SizedBox(height: 16),
                _buildTextInput(
                  'Event Description',
                  'Enter event description',
                  _descriptionController,
                  (value) => value == null || value.isEmpty ? 'Please enter event description' : null,
                ),
                const SizedBox(height: 16),

                // Date and time picker for Start
                CreateEventDatePicker(
                  label: "Start",
                  date: _startDate,
                  time: _startTime,
                  onDatePicked: (pickedDate) => setState(() => _startDate = pickedDate),
                  onTimePicked: (pickedTime) => setState(() => _startTime = pickedTime),
                ),
                const SizedBox(height: 16),

                // Date and time picker for End
                CreateEventDatePicker(
                  label: "End",
                  date: _endDate,
                  time: _endTime,
                  onDatePicked: (pickedDate) => setState(() => _endDate = pickedDate),
                  onTimePicked: (pickedTime) => setState(() => _endTime = pickedTime),
                ),
                const SizedBox(height: 16),

                // Dropdown for Category Selection
                _buildCategoryDropdown(),

                const SizedBox(height: 16),
                _buildTextInput(
                  'Choose Venue',
                  'Enter Venue',
                  _venueController,
                  (value) => value == null || value.isEmpty ? 'Please enter venue name' : null,
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => _createEvent(context, fullImageUrl, croppedImageUrl),
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
      },
    );
  }

  // Dropdown for Category
  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 8),
        CustomInputBox(
          isDropdown: true,
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            hint: const Text('Select Category'),
            items: <String>['Conference', 'Workshop', 'Meetup', 'Seminar', 'Other']
                .map((String value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (newValue) => setState(() => _selectedCategory = newValue),
            decoration: const InputDecoration(border: InputBorder.none),
            validator: (value) => value == null || value.isEmpty ? 'Please select a category' : null,
          ),
        ),
      ],
    );
  }

  // Text Input Box
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
        CustomInputBox(
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
