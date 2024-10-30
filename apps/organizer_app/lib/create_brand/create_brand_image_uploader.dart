import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:organizer_app/create_brand/bloc/create_brand_form_bloc.dart';
import 'package:organizer_app/create_brand/bloc/create_brand_form_event.dart';
import 'package:organizer_app/create_brand/bloc/create_brand_form_state.dart';
import 'package:organizer_app/create_brand/repositories/brand_logo_upload_service.dart';

class CreateBrandLogoUpload extends StatefulWidget {
  final String brandId;
  final BrandLogoUploadService uploadService;

  const CreateBrandLogoUpload({
    Key? key,
    required this.brandId,
    required this.uploadService,
  }) : super(key: key);

  @override
  CreateBrandLogoUploadState createState() => CreateBrandLogoUploadState();
}

class CreateBrandLogoUploadState extends State<CreateBrandLogoUpload> {
  final ImagePicker _picker = ImagePicker();
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
      );

      if (croppedFile != null) {
        setState(() => _croppedImageFile = File(croppedFile.path));
        await _uploadImages(context);
      }
    } catch (e) {
      print('Error selecting or cropping image: $e'); // Debugging print statement
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting or cropping image: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _uploadImages(BuildContext context) async {
    if (_croppedImageFile == null) return;

    setState(() => _isUploading = true);
    print('Starting image upload...'); // Debugging print statement

    try {
      final urls = await widget.uploadService.pickAndUploadImage(widget.brandId);
      print('Image upload complete with URLs: $urls'); // Debugging print statement

      if (!mounted) return;

      if (urls != null) {
        context.read<CreateBrandFormBloc>().add(UpdateCreateBrandLogoUrls(
          brandId: widget.brandId,
          fullImageUrl: urls['brandLogoImageFullUrl']!,
          croppedImageUrl: urls['brandLogoImageCroppedUrl']!,
        ));
        print('State updated with image URLs'); // Debugging print statement
      }
    } catch (e) {
      print('Error uploading images: $e'); // Debugging print statement
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading images: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isUploading = false);
      print('Reset _isUploading to false'); // Debugging print statement
    }
  }

  void _deleteImage(BuildContext context) {
    context.read<CreateBrandFormBloc>().add(const DeleteCreateBrandLogo());
    setState(() {
      _croppedImageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBrandFormBloc, CreateBrandFormState>(
      builder: (context, state) {
        if (_isUploading) {
          print('Uploader is loading...'); // Debugging print statement
          return const Center(child: CircularProgressIndicator());
        } else if (_croppedImageFile != null || (state is CreateBrandFormImageUrlsUpdated)) {
          final imageUrl = state is CreateBrandFormImageUrlsUpdated ? state.croppedImageUrl : null;
          return Stack(
            children: [
              if (_croppedImageFile != null)
                Image.file(
                  _croppedImageFile!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                )
              else if (imageUrl != null)
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteImage(context),
                ),
              ),
            ],
          );
        } else {
          print('Uploader is idle, waiting for image'); // Debugging print statement
          return GestureDetector(
            onTap: () => _pickAndCropImage(context),
            child: Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'Tap to upload an image. Max size: 1MB. Formats: jpg, png.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
