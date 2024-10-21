import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organizer_app/widgets/create_event_date_picker.dart'; // Reuse existing widget
import 'package:shared/widgets/custom_input_box.dart'; // Use CustomInputBox for consistency

class EditEventScreen extends StatefulWidget {
  final String eventId;

  const EditEventScreen({super.key, required this.eventId});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

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
    _fetchEventData();
  }

  // Fetch event data from Firestore
  Future<void> _fetchEventData() async {
    try {
      final DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .get();

      if (eventSnapshot.exists) {
        final Map<String, dynamic> data = eventSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _eventNameController.text = data['eventName'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _venueController.text = data['venue'] ?? '';
          _urlController.text = data['imageUrl'] ?? '';
          _startDate = (data['startDateTime'] as Timestamp).toDate();
          _endDate = (data['endDateTime'] as Timestamp).toDate();
          _selectedCategory = data['category'] ?? '';
          _isLoading = false;
        });
      } else {
        _showError('Event not found.');
        Navigator.pop(context);
      }
    } catch (e) {
      _showError('Error fetching event: $e');
      Navigator.pop(context);
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      try {
        await FirebaseFirestore.instance.collection('events').doc(widget.eventId).update({
          'eventName': _eventNameController.text,
          'description': _descriptionController.text,
          'venue': _venueController.text,
          'imageUrl': _urlController.text,
          'category': _selectedCategory ?? '',
          'startDateTime': Timestamp.fromDate(_startDate!),
          'endDateTime': Timestamp.fromDate(_endDate!),
        });
        Navigator.pop(context, true);
      } catch (e) {
        _showError('Error updating event: $e');
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  // Utility function to show error messages
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Event')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextInput('Event Name', _eventNameController, 'Enter event name'),
                    const SizedBox(height: 16),
                    _buildTextInput('Description', _descriptionController, 'Enter event description'),
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

  // Text input builder for form fields
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

  // Dropdown for selecting the category
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
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) => setState(() => _selectedCategory = newValue),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}
