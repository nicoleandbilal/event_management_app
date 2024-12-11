import 'package:equatable/equatable.dart';

abstract class ImageUploaderState extends Equatable {
  const ImageUploaderState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ImageUploaderInitial extends ImageUploaderState {}

/// State indicating image upload is in progress
class EventImageUploading extends ImageUploaderState {}

/// State when images are successfully uploaded
class EventImageUploadSuccess extends ImageUploaderState {
  final String? fullImageUrl;
  final String? croppedImageUrl;

  const EventImageUploadSuccess({
    this.fullImageUrl,
    this.croppedImageUrl,
  });

  @override
  List<Object?> get props => [fullImageUrl, croppedImageUrl];
}

/// State indicating image deletion is in progress
class EventImageDeleting extends ImageUploaderState {}

/// State when images are successfully deleted
class EventImageDeleteSuccess extends ImageUploaderState {}

/// State for errors
class ImageUploaderError extends ImageUploaderState {
  final String errorMessage;

  const ImageUploaderError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}