import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:organizer_app/create_brand_new/blocs/create_brand_form_bloc.dart';
import 'package:organizer_app/create_brand_new/blocs/create_brand_form_event.dart';
import 'package:organizer_app/create_brand_new/blocs/create_brand_form_state.dart';
import 'package:organizer_app/create_brand_new/brand_image_upload_service.dart';

class CreateBrandImageUpload extends StatefulWidget {
  final ImageUploadService imageUploadService;

  const CreateBrandImageUpload({
    super.key, 
    required this.imageUploadService
    });

  @override
  CreateBrandImageUploadState createState() => CreateBrandImageUploadState();
}

class CreateBrandImageUploadState extends State<CreateBrandImageUpload> {
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
      final urls = await widget.imageUploadService.uploadFullAndCroppedImages(
        _fullImageFile!,
        _croppedImageFile!,
      );

      final fullImageUrl = urls['fullImageUrl'];
      final croppedImageUrl = urls['croppedImageUrl'];

      // Dispatch both URLs in a single event
      if (fullImageUrl != null && croppedImageUrl != null && mounted) {
        context.read<CreateBrandFormBloc>().add(UpdateImageUrls(
          fullImageUrl: fullImageUrl,
          croppedImageUrl: croppedImageUrl,
        ));
      } else {
        throw Exception("Image URLs missing after upload.");
      }

      setState(() {
        _isUploading = false;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _showError(context, 'Error uploading images: $e');
    }
  }

  void _deleteImages(BuildContext context) {
    context.read<CreateBrandFormBloc>().add(const DeleteImageUrls());
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
    return BlocBuilder<CreateBrandFormBloc, CreateBrandFormState>(
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
