import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_bloc.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_event.dart';
import 'package:organizer_app/create_event/blocs/create_event_form_state.dart';
import 'package:organizer_app/create_event/repositories/image_repository.dart';

class CreateEventImageUpload extends StatefulWidget {
  final TextEditingController urlController;

  const CreateEventImageUpload({required this.urlController, super.key});

  @override
  CreateEventImageUploadState createState() => CreateEventImageUploadState();
}

class CreateEventImageUploadState extends State<CreateEventImageUpload> {
  final ImagePicker _picker = ImagePicker();
  File? _fullImageFile;
  File? _croppedImageFile;
  bool _isUploading = false;

  final ImageRepository _imageRepository = ImageRepository();

  Future<void> _pickAndCropImage(BuildContext context) async {
    try {
      // Pick image
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,  // Limit initial image size
        maxHeight: 1080,
      );

      if (pickedFile == null) return;

      // Convert XFile to File
      File imageFile = File(pickedFile.path);
      
      // Crop image using updated configuration
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
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _fullImageFile = imageFile;
          _croppedImageFile = File(croppedFile.path);
        });

        await _uploadImages(context);
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error picking or cropping image: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _uploadImages(BuildContext context) async {
    if (_fullImageFile == null || _croppedImageFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final fullImagePath = 'event_images/${DateTime.now().millisecondsSinceEpoch}_full.jpg';
      final croppedImagePath = 'event_images/${DateTime.now().millisecondsSinceEpoch}_cropped.jpg';

      // Compress images before uploading
      final compressedFullImage = await _imageRepository.compressImage(_fullImageFile!);
      final compressedCroppedImage = await _imageRepository.compressImage(_croppedImageFile!);

      final urls = await _imageRepository.uploadFullAndCroppedImage(
        fullImageFile: compressedFullImage,
        croppedImageFile: compressedCroppedImage,
        fullImagePath: fullImagePath,
        croppedImagePath: croppedImagePath,
      );

      if (!mounted) return;

      widget.urlController.text = urls['eventCoverImageCroppedUrl']!;
      context.read<CreateEventFormBloc>().add(UpdateCreateEventImageUrl(urls['eventCoverImageCroppedUrl']!));

      setState(() {
        _isUploading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isUploading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error uploading image: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventFormBloc, CreateEventFormState>(
      builder: (context, state) {
        if (_isUploading) {
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
                  onPressed: () {
                    context.read<CreateEventFormBloc>().add(const DeleteCreateEventImage());
                    setState(() {
                      _croppedImageFile = null;
                      _fullImageFile = null;
                      widget.urlController.clear();
                    });
                  },
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