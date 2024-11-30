import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_event.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_state.dart';
import 'package:organizer_app/event_creation/event_cover_image/create_event_image_upload.dart';
import 'package:shared/date_and_time_picker/date_and_time_picker.dart';

class BasicDetailsScreen extends StatefulWidget {
  final String eventId;

  const BasicDetailsScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends State<BasicDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _eventNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _venueController;

  @override
  void initState() {
    super.initState();

    // Initialize form controllers
    _eventNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _venueController = TextEditingController();

    // Load initial data after Bloc state is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<BasicDetailsBloc>().state;
      if (state is BasicDetailsValid) {
        _loadInitialData(state.formData);
      }
    });
  }

  void _loadInitialData(Map<String, dynamic> formData) {
    _eventNameController.text = formData['eventName'] ?? '';
    _descriptionController.text = formData['description'] ?? '';
    _venueController.text = formData['venue'] ?? '';
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BasicDetailsBloc, BasicDetailsState>(
      listener: (context, state) {
        if (state is BasicDetailsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        final formData =
            state is BasicDetailsValid ? state.formData : <String, dynamic>{};

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Event Details",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildTextInput(
                  label: "Event Name",
                  controller: _eventNameController,
                  onChanged: (value) => context
                      .read<BasicDetailsBloc>()
                      .add(UpdateField(field: "eventName", value: value)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Event name is required.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                CreateEventImageUpload(eventId: widget.eventId),
                const SizedBox(height: 16.0),
                _buildTextInput(
                  label: "Event Description",
                  controller: _descriptionController,
                  maxLines: 4,
                  onChanged: (value) => context
                      .read<BasicDetailsBloc>()
                      .add(UpdateField(field: "description", value: value)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Event description is required.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                _buildDateAndTimePicker(
                  label: "Start Date & Time",
                  formData: formData,
                  isStart: true,
                ),
                const SizedBox(height: 16.0),
                _buildDateAndTimePicker(
                  label: "End Date & Time",
                  formData: formData,
                  isStart: false,
                ),
                const SizedBox(height: 16.0),
                _buildTextInput(
                  label: "Venue",
                  controller: _venueController,
                  onChanged: (value) => context
                      .read<BasicDetailsBloc>()
                      .add(UpdateField(field: "venue", value: value)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Venue is required.";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextInput({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: "Enter $label",
            border: const OutlineInputBorder(),
          ),
          validator: validator,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDateAndTimePicker({
    required String label,
    required Map<String, dynamic> formData,
    required bool isStart,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8.0),
        CreateEventDatePicker(
          label: label,
          date: formData[isStart ? "startDateTime" : "endDateTime"],
          time: formData[isStart ? "startTime" : "endTime"],
          onDatePicked: (pickedDate) => context.read<BasicDetailsBloc>().add(
                UpdateField(
                  field: isStart ? "startDateTime" : "endDateTime",
                  value: pickedDate,
                ),
              ),
          onTimePicked: (pickedTime) => context.read<BasicDetailsBloc>().add(
                UpdateField(
                  field: isStart ? "startTime" : "endTime",
                  value: pickedTime,
                ),
              ),
        ),
      ],
    );
  }
}