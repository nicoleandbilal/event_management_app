// create_event_image_uploader.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_bloc.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_event.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_state.dart';

class CreateEventImageUpload extends StatefulWidget {
  final TextEditingController urlController;

  const CreateEventImageUpload({required this.urlController, super.key});

  @override
  _CreateEventImageUploadState createState() => _CreateEventImageUploadState();
}

class _CreateEventImageUploadState extends State<CreateEventImageUpload> {
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Trigger the event to upload the image
      context.read<CreateEventFormBloc>().add(UpdateCreateEventImageUrl(imageFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventFormBloc, CreateEventFormState>(
      builder: (context, state) {
        if (state is CreateEventFormInitial || state is CreateEventFormImageUploading) {
          return GestureDetector(
            onTap: () => _pickImage(context),
            child: Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Images can be up to 1MB. Accepted Formats: jpg, png, gif. Size: 1600px by 900px',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        } else if (state is CreateEventFormImageUploading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CreateEventFormImageUploaded) {
          widget.urlController.text = state.imageUrl;  // Save the image URL to the controller
          return Stack(
            children: [
              Image.network(
                state.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete the image and reset the state
                    context.read<CreateEventFormBloc>().add(const DeleteCreateEventImage());
                    widget.urlController.clear();
                  },
                ),
              ),
            ],
          );
        } else if (state is CreateEventFormFailure) {
          return Column(
            children: [
              const Text('Error uploading image. Please try again.'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _pickImage(context),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Images can be up to 1MB. Accepted Formats: jpg, png, gif. Size: 1600px by 900px',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
