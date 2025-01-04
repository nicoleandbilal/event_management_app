import 'package:equatable/equatable.dart';

abstract class ImageUploaderState extends Equatable {
  const ImageUploaderState();

  @override
  List<Object?> get props => [];
}

class ImageUploaderInitial extends ImageUploaderState {}

class ImageUploading extends ImageUploaderState {}

class ImagesUploaded extends ImageUploaderState {
  final String fullImageUrl;
  final String croppedImageUrl;

  const ImagesUploaded(this.fullImageUrl, this.croppedImageUrl);

  @override
  List<Object?> get props => [fullImageUrl, croppedImageUrl];
}

class ImageUploaderError extends ImageUploaderState {
  final String error;

  const ImageUploaderError(this.error);

  @override
  List<Object?> get props => [error];
}