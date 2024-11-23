// basic_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/event_cover_image/create_event_image_upload.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_event.dart';
import 'package:organizer_app/event_creation/basic_details/bloc/basic_details_state.dart';
import 'package:shared/date_and_time_picker/date_and_time_picker.dart';

class BasicDetailsScreen extends StatefulWidget {
  final String eventId;
  
  // final String brandId; // Include brandId
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
  String? _selectedCategory;

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  void _submitForm(BasicDetailsBloc bloc) {
    if (_formKey.currentState?.validate() == true) {
      bloc.add(SubmitBasicDetails());
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
            } else if (state is BasicDetailsValidationFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Missing fields: ${state.missingFields.join(", ")}',
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final bloc = context.read<BasicDetailsBloc>();
      
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
                      onChanged: (value) => bloc.add(UpdateField(field: "eventName", value: value)),
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
                      onChanged: (value) => bloc.add(UpdateField(field: "description", value: value)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Event description is required.";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16.0),
                    _buildDateAndTimePicker(
                      bloc: bloc,
                      label: "Start Date & Time",
                      isStart: true,
                    ),

                    const SizedBox(height: 16.0),
                    _buildDateAndTimePicker(
                      bloc: bloc,
                      label: "End Date & Time",
                      isStart: false,
                    ),
                    const SizedBox(height: 16.0),
                    _buildCategoryDropdown(bloc),

                    const SizedBox(height: 16.0),
                    _buildTextInput(
                      label: "Venue",
                      controller: _venueController,
                      onChanged: (value) => bloc.add(UpdateField(field: "venue", value: value)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Venue is required.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _submitForm(bloc),
                        child: const Text("Save Details"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: label,
            border: const OutlineInputBorder(),
          ),
          validator: validator,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDateAndTimePicker({
    required BasicDetailsBloc bloc,
    required String label,
    required bool isStart,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 8.0),
        CreateEventDatePicker(
          label: label,
          date: isStart
              ? bloc.formData["startDateTime"]
              : bloc.formData["endDateTime"],
          time: isStart
              ? bloc.formData["startTime"]
              : bloc.formData["endTime"],
          onDatePicked: (pickedDate) => bloc.add(UpdateField(
              field: isStart ? "startDateTime" : "endDateTime", value: pickedDate)),
          onTimePicked: (pickedTime) => bloc.add(UpdateField(
              field: isStart ? "startTime" : "endTime", value: pickedTime)),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(BasicDetailsBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Choose Category",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          items: ['Conference', 'Workshop', 'Meetup', 'Seminar', 'Other']
              .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
              .toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedCategory = newValue;
              bloc.add(UpdateField(field: "category", value: newValue));
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
