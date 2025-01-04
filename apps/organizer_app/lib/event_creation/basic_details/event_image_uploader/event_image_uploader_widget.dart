import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:logger/logger.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/blocs/event_image_uploader_bloc.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/blocs/event_image_uploader_event.dart';
import 'package:organizer_app/event_creation/basic_details/event_image_uploader/blocs/event_image_uploader_state.dart';

class ImageUploaderWidget extends StatelessWidget {
  const ImageUploaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageUploaderBloc, ImageUploaderState>(
      builder: (context, state) {
        if (state is ImageUploaderInitial) {
          return _buildPlusIcon(context);
        } else if (state is ImageUploading) {
          return const CircularProgressIndicator();
        } else if (state is ImagesUploaded) {
          return _buildImagePreview(context, state.croppedImageUrl);
        } else if (state is ImageUploaderError) {
          return _buildErrorState(context, state.error);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildPlusIcon(BuildContext context) {
    final logger = Logger();

    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();

        try {
          final selectedImage = await picker.pickImage(source: ImageSource.gallery);
          if (selectedImage == null) {
            logger.i('No image selected.');
            return;
          }

          final croppedImage = await _cropImage(File(selectedImage.path), logger);
          if (croppedImage == null) {
            logger.i('Image cropping canceled.');
            return;
          }

          if (!context.mounted) return;

          context.read<ImageUploaderBloc>().add(
                ImagesSelected(
                  File(selectedImage.path),
                  croppedImage,
                ),
              );
        } catch (e) {
          logger.e('Error selecting or cropping image: $e');
        }
      },
      child: AspectRatio(
        aspectRatio: 1920 / 1080,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.add, size: 50),
        ),
      ),
    );
  }

  Future<File?> _cropImage(File imageFile, Logger logger) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1920, ratioY: 1080),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.blue,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      logger.e('Error cropping image: $e');
      return null;
    }
  }

  Widget _buildImagePreview(BuildContext context, String croppedImageUrl) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1920 / 1080,
          child: Image.network(croppedImageUrl, fit: BoxFit.cover),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              context.read<ImageUploaderBloc>().add(ImagesDeleted());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.delete, color: Colors.white, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return GestureDetector(
      onTap: () {
        context.read<ImageUploaderBloc>().add(ImagesDeleted());
      },
      child: Container(
        color: Colors.red[200],
        child: Text(error, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}