import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ImageUploaderEvent extends Equatable {
  const ImageUploaderEvent();

  @override
  List<Object?> get props => [];
}

/// Event to upload event images
class UploadEventImage extends ImageUploaderEvent {
  final File fullImage;
  final File croppedImage;
  final String eventId;

  const UploadEventImage({
    required this.fullImage,
    required this.croppedImage,
    required this.eventId,
  });

  @override
  List<Object?> get props => [fullImage, croppedImage, eventId];
}

/// Event to delete uploaded images
class DeleteEventImage extends ImageUploaderEvent {
  final String eventId;

  const DeleteEventImage(this.eventId);

  @override
  List<Object?> get props => [eventId];
}