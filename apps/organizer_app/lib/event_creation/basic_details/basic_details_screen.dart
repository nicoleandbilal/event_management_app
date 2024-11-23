import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_event.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_state.dart';
import 'package:organizer_app/event_creation/event_cover_image/create_event_image_upload.dart';
import 'package:shared/date_and_time_picker/date_and_time_picker.dart';

class BasicDetailsScreen extends StatefulWidget {
  final String eventId;
  final Function(Map<String, dynamic>) onUpdateFormData;

  const BasicDetailsScreen({
    super.key,
    required this.eventId,
    required this.onUpdateFormData,
  });

  @override
  BasicDetailsScreenState createState() => BasicDetailsScreenState();
}

class BasicDetailsScreenState extends State<BasicDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context, {bool saveAndExit = false}) {
    if (_formKey.currentState?.validate() == true) {
      final bloc = context.read<BasicDetailsBloc>();
      bloc.add(
        SubmitBasicDetails(saveAndExit: saveAndExit),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BasicDetailsBloc(
        eventRepository: context.read(),
        imageUploadService: context.read(),
        eventId: widget.eventId,
      ),
      child: BlocConsumer<BasicDetailsBloc, BasicDetailsState>(
        listener: (context, state) {
          if (state is BasicDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is BasicDetailsValid) {
            widget.onUpdateFormData(state.formData);
          }
        },
        builder: (context, state) {
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
                    isStart: true,
                  ),
                  const SizedBox(height: 16.0),
                  _buildDateAndTimePicker(
                    label: "End Date & Time",
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
                  const SizedBox(height: 24.0),
                  _buildButtons(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => _submitForm(context, saveAndExit: true),
          child: const Text("Save & Exit"),
        ),
        ElevatedButton(
          onPressed: () => _submitForm(context, saveAndExit: false),
          child: const Text("Next"),
        ),
      ],
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
            border: OutlineInputBorder(),
          ),
          validator: validator,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDateAndTimePicker({
    required String label,
    required bool isStart,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8.0),
        CreateEventDatePicker(
          label: label,
          date: context
              .read<BasicDetailsBloc>()
              .formData[isStart ? "startDateTime" : "endDateTime"],
          time: context
              .read<BasicDetailsBloc>()
              .formData[isStart ? "startTime" : "endTime"],
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
