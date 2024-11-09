import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_bloc.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_event.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_state.dart';
import 'package:organizer_app/create_event/event_cover_image/event_image_upload_service.dart';

/// Widget that handles the image upload and display functionality for event cover images.
/// Allows users to select, crop, and upload images, with options to delete them.
class CreateEventImageUpload extends StatefulWidget {
  final ImageUploadService imageUploadService; // Image upload service for handling uploads
  final String eventId; // Event ID to associate with the uploaded images

  const CreateEventImageUpload({
    super.key,
    required this.imageUploadService,
    required this.eventId,
  });

  @override
  CreateEventImageUploadState createState() => CreateEventImageUploadState();
}

class CreateEventImageUploadState extends State<CreateEventImageUpload> {
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance for selecting images
  File? _fullImageFile; // Full-size image file selected by the user
  File? _croppedImageFile; // Cropped version of the selected image
  bool _isUploading = false; // Boolean to track upload status

  /// Method to handle image picking and cropping. Opens the gallery, allows cropping,
  /// and saves the cropped file locally.
  Future<void> _pickAndCropImage(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile == null) return; // If no image was selected, exit

      final File imageFile = File(pickedFile.path); // Convert the picked file to a File object

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
        compressQuality: 85,
        maxWidth: 1600,
        maxHeight: 900,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _fullImageFile = imageFile;
          _croppedImageFile = File(croppedFile.path);
        });
        await _uploadImages(context); // Trigger image upload
      }
    } catch (e) {
      _showError(context, 'Error selecting or cropping image: $e'); // Show an error if image picking or cropping fails
    }
  }

  /// Handles uploading both the full and cropped images. Dispatches URLs to the Bloc upon success.
  Future<void> _uploadImages(BuildContext context) async {
    if (_fullImageFile == null || _croppedImageFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      context.read<CreateEventFormBloc>().add(
        UpdateImageUrls(
          fullImage: _fullImageFile!,
          croppedImage: _croppedImageFile!,
          eventId: widget.eventId,
        ),
      );
    } catch (e) {
      _showError(context, e is ImageUploadException ? e.message : 'Error uploading images: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  /// Deletes the images by clearing local files and dispatching to the Bloc.
  void _deleteImages(BuildContext context) {
    context.read<CreateEventFormBloc>().add(const DeleteImageUrls());
    setState(() {
      _fullImageFile = null;
      _croppedImageFile = null;
    });
  }

  /// Shows error messages to the user using a SnackBar.
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  /// Builds the widget UI: shows the image, delete button, or placeholder based on state.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventFormBloc, CreateEventFormState>(
      builder: (context, state) {
        if (_isUploading) {
          return const Center(child: CircularProgressIndicator()); // Show a loading indicator if uploading
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
