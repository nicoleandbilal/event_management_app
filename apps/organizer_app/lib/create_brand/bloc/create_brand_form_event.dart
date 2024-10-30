import 'package:equatable/equatable.dart';
import 'package:shared/models/brand_model.dart';

abstract class CreateBrandFormEvent extends Equatable {
  const CreateBrandFormEvent();

  @override
  List<Object?> get props => [];
}

// Event to submit the form with brand details
class SubmitCreateBrandForm extends CreateBrandFormEvent {
  final Brand brand;
  const SubmitCreateBrandForm(this.brand);

  @override
  List<Object?> get props => [brand];
}

// Event for image picking and uploading
class PickAndUploadImage extends CreateBrandFormEvent {
  final String brandId;
  const PickAndUploadImage({required this.brandId});

  @override
  List<Object?> get props => [brandId];
}

// Event to update brand logo URLs after upload
class UpdateCreateBrandLogoUrls extends CreateBrandFormEvent {
  final String brandId;
  final String fullImageUrl;
  final String croppedImageUrl;

  const UpdateCreateBrandLogoUrls({
    required this.brandId,
    required this.fullImageUrl,
    required this.croppedImageUrl,
  });

  @override
  List<Object?> get props => [brandId, fullImageUrl, croppedImageUrl];
}

// Event to delete brand logo
class DeleteCreateBrandLogo extends CreateBrandFormEvent {
  const DeleteCreateBrandLogo();
}
