import 'package:equatable/equatable.dart';

abstract class ImageUploaderState extends Equatable {
  const ImageUploaderState();

  @override
  List<Object?> get props => [];
}

class ImageUploaderInitial extends ImageUploaderState {}

class EventImageUploading extends ImageUploaderState {}

// State for successful image upload
class EventImageUploadSuccess extends ImageUploaderState {
  final String? fullImageUrl;
  final String? croppedImageUrl;

  const EventImageUploadSuccess(this.fullImageUrl, this.croppedImageUrl);

  @override
  List<Object?> get props => [fullImageUrl, croppedImageUrl];
}

class EventImageDeleting extends ImageUploaderState {}

class EventImageDeleteSuccess extends ImageUploaderState {}

class ImageUploaderError extends ImageUploaderState {
  final String errorMessage;

  const ImageUploaderError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}