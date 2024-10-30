import 'package:equatable/equatable.dart';
import 'package:shared/models/brand_model.dart';

abstract class CreateBrandFormEvent extends Equatable {
  const CreateBrandFormEvent();
}

// Event to submit the form with brand details
class SubmitCreateBrandForm extends CreateBrandFormEvent {
  final Brand brand;
  const SubmitCreateBrandForm(this.brand);

  @override
  List<Object?> get props => [brand];
}

class UpdateImageUrls extends CreateBrandFormEvent {
  final String fullImageUrl;
  final String croppedImageUrl;

  const UpdateImageUrls({required this.fullImageUrl, required this.croppedImageUrl});

  @override
  List<Object?> get props => [fullImageUrl, croppedImageUrl];
}

class DeleteImageUrls extends CreateBrandFormEvent {
  const DeleteImageUrls();

  @override
  List<Object?> get props => [];
}
