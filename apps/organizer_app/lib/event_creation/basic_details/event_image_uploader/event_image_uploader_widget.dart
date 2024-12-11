// event_image_uploader_widget.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/blocs/event_image_uploader_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/blocs/event_image_uploader_event.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/blocs/event_image_uploader_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageUploaderWidget extends StatefulWidget {
  final String eventId;

  const ImageUploaderWidget({super.key, required this.eventId});

  @override
  State<ImageUploaderWidget> createState() => _ImageUploaderWidgetState();
}

class _ImageUploaderWidgetState extends State<ImageUploaderWidget> {
  final ImagePicker _picker = ImagePicker();
  File? _fullImageFile;
  File? _croppedImageFile;

  Future<void> _pickAndCropImage(BuildContext context) async {
    try {
      final pickedFile = await _picker.pickImage(
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
      );
      if (croppedFile != null) {
        setState(() {
          _fullImageFile = imageFile;
          _croppedImageFile = File(croppedFile.path);
        });

        context.read<ImageUploaderBloc>().add(
              UploadEventImage(
                fullImage: _fullImageFile!,
                croppedImage: _croppedImageFile!,
                eventId: widget.eventId,
              ),
            );
      }
    } catch (e) {
      _showError(context, 'Error selecting or cropping image: $e');
    }
  }

  void _deleteImages(BuildContext context) {
    context.read<ImageUploaderBloc>().add(DeleteEventImage(widget.eventId));
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
    if (widget.eventId.isEmpty) {
      return const Center(
        child: Text('Unable to upload images. Event ID is missing.'),
      );
    }

    return BlocConsumer<ImageUploaderBloc, ImageUploaderState>(
      listener: (context, state) {
        if (state is ImageUploaderError) {
          _showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is EventImageUploading) {
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

/*

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:organizer_app/event_creation/basic_details/blocs/basic_details_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/blocs/basic_details_event.dart';
import 'package:organizer_app/event_creation/basic_details/blocs/basic_details_state.dart';

class CreateEventImageUpload extends StatefulWidget {
  final String eventId;

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
      final pickedFile = await _picker.pickImage(
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
      context.read<BasicDetailsBloc>().add(
        UploadEventImage(
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
    context.read<BasicDetailsBloc>().add(DeleteEventImage());
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
    if (widget.eventId.isEmpty) {
      return const Center(
        child: Text('Unable to upload images. Event ID is missing.'),
      );
    }

    return BlocBuilder<BasicDetailsBloc, BasicDetailsState>(
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

*/