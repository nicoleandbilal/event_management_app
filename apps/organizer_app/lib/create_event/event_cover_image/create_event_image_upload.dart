// create_event_image_upload.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:organizer_app/create_event/event_details/bloc/event_details_bloc.dart';
import 'package:organizer_app/create_event/event_details/bloc/event_details_event.dart';
import 'package:organizer_app/create_event/event_details/bloc/event_details_state.dart';

class CreateEventImageUpload extends StatefulWidget {
  final String eventId; // Add the eventId parameter to allow passing the event ID

  const CreateEventImageUpload({
    super.key,
    required this.eventId,
  });

  @override
  CreateEventImageUploadState createState() => CreateEventImageUploadState();
}

class CreateEventImageUploadState extends State<CreateEventImageUpload> {
  final ImagePicker _picker = ImagePicker();
  File? _fullImageFile;
  File? _croppedImageFile;
  bool _isUploading = false;

  Future<void> _pickAndCropImage(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile == null) return;

      final File imageFile = File(pickedFile.path);

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
        compressQuality: 85,
        maxWidth: 1600,
        maxHeight: 900,
        compressFormat: ImageCompressFormat.jpg,
      );

      if (croppedFile != null) {
        setState(() {
          _fullImageFile = imageFile;
          _croppedImageFile = File(croppedFile.path);
        });
        await _uploadImages(context);
      }
    } catch (e) {
      _showError(context, 'Error selecting or cropping image: $e');
    }
  }

  Future<void> _uploadImages(BuildContext context) async {
    if (_fullImageFile == null || _croppedImageFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      context.read<EventDetailsBloc>().add(
        UploadEventImageEvent(
          fullImage: _fullImageFile!,
          croppedImage: _croppedImageFile!,
        ),
      );
    } catch (e) {
      _showError(context, 'Error uploading images: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _deleteImages(BuildContext context) {
    context.read<EventDetailsBloc>().add(DeleteEventImageEvent());
    setState(() {
      _fullImageFile = null;
      _croppedImageFile = null;
    });
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailsBloc, EventDetailsState>(
      builder: (context, state) {
        if (_isUploading || state is EventImageUploading) {
          return const Center(child: CircularProgressIndicator());
        } else if (_croppedImageFile != null) {
          return Stack(
            children: [
              Image.file(
                _croppedImageFile!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteImages(context),
                ),
              ),
            ],
          );
        } else {
          return GestureDetector(
            onTap: () => _pickAndCropImage(context),
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
        }
      },
    );
  }
}
