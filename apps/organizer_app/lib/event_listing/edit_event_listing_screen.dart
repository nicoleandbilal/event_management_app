import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/services/event_image_uploader_service.dart';
import 'package:shared/date_and_time_picker/date_and_time_picker.dart';
import 'package:shared/widgets/custom_input_box.dart';
import 'package:shared/repositories/event_repository.dart';

class EditEventScreen extends StatefulWidget {
  final String eventId;

  const EditEventScreen({super.key, required this.eventId});

  @override
  EditEventScreenState createState() => EditEventScreenState();
}

class EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _urlController = TextEditingController();

  final _eventRepository = GetIt.instance<EventRepository>();
  final _imageUploaderService = GetIt.instance<ImageUploaderService>();

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  String? _selectedCategory;

  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  Future<void> _loadEventData() async {
    try {
      final event = await _eventRepository.getEvent(widget.eventId);
      if (event != null) {
        setState(() {
          _eventNameController.text = event.eventName ?? '';
          _descriptionController.text = event.description ?? '';
          _venueController.text = event.venue ?? '';
          _urlController.text = event.eventCoverImageFullUrl ?? '';
          _startDate = event.startDateTime;
          _startTime = TimeOfDay.fromDateTime(event.startDateTime);
          _endDate = event.endDateTime;
          _endTime = TimeOfDay.fromDateTime(event.endDateTime);
          _selectedCategory = event.category;
          _isLoading = false;
        });
      } else {
        _showError('Event not found');
        Navigator.pop(context);
      }
    } catch (e) {
      _showError('Failed to load event: $e');
      Navigator.pop(context);
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_startDate == null || _startTime == null || _endDate == null || _endTime == null) {
        _showError('Please select both start and end date/time');
        return;
      }

      setState(() => _isSubmitting = true);

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

      try {
        await _eventRepository.updateEventFields(
          widget.eventId,
          {
            'eventName': _eventNameController.text,
            'description': _descriptionController.text,
            'venue': _venueController.text,
            'eventCoverImageFullUrl': _urlController.text,
            'category': _selectedCategory ?? '',
            'startDateTime': startDateTime,
            'endDateTime': endDateTime,
          },
        );
        Navigator.pop(context, true);
      } catch (e) {
        _showError('Failed to update event: $e');
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Event')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextInput('Event Name', _eventNameController, 'Enter event name'),
                    const SizedBox(height: 16),
                    _buildTextInput('Description', _descriptionController, 'Enter description'),
                    const SizedBox(height: 16),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 16),
                    _buildTextInput('Venue', _venueController, 'Enter venue'),
                    const SizedBox(height: 16),
                    CreateEventDatePicker(
                      label: 'Start Date & Time',
                      date: _startDate,
                      time: _startTime,
                      onDatePicked: (date) => setState(() => _startDate = date),
                      onTimePicked: (time) => setState(() => _startTime = time),
                    ),
                    const SizedBox(height: 16),
                    CreateEventDatePicker(
                      label: 'End Date & Time',
                      date: _endDate,
                      time: _endTime,
                      onDatePicked: (date) => setState(() => _endDate = date),
                      onTimePicked: (time) => setState(() => _endTime = time),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const CircularProgressIndicator()
                          : const Text('Update Event'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextInput(String label, TextEditingController controller, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        CustomInputBox(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: hintText, border: InputBorder.none),
            validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        CustomInputBox(
          isDropdown: true,
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: <String>['Conference', 'Workshop', 'Meetup', 'Seminar']
                .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (newValue) => setState(() => _selectedCategory = newValue),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}