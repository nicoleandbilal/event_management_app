import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ImageUploaderEvent extends Equatable {
  const ImageUploaderEvent();

  @override
  List<Object?> get props => [];
}

class ImagesSelected extends ImageUploaderEvent {
  final File fullImage;
  final File croppedImage;

  const ImagesSelected(this.fullImage, this.croppedImage);

  @override
  List<Object?> get props => [fullImage, croppedImage];
}

class ImagesDeleted extends ImageUploaderEvent {}