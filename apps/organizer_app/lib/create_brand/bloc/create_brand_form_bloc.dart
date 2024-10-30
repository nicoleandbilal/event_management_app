import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_brand/bloc/create_brand_form_event.dart';
import 'package:organizer_app/create_brand/bloc/create_brand_form_state.dart';
import 'package:organizer_app/create_brand/repositories/brand_logo_upload_service.dart';
import 'package:organizer_app/create_brand/repositories/brand_repository.dart';

class CreateBrandFormBloc extends Bloc<CreateBrandFormEvent, CreateBrandFormState> {
  final BrandRepository brandRepository;
  final BrandLogoUploadService uploadService;

  CreateBrandFormBloc({
    required this.brandRepository,
    required this.uploadService,
  }) : super(CreateBrandFormInitial()) {
    // Registering event handlers
    on<PickAndUploadImage>(_onPickAndUploadImage);
    on<SubmitCreateBrandForm>(_onSubmitCreateBrandForm);
  }

  Future<void> _onPickAndUploadImage(
    PickAndUploadImage event,
    Emitter<CreateBrandFormState> emit,
  ) async {
    emit(CreateBrandFormImageUploading()); // Emitting uploading state
    try {
      final imageUrls = await uploadService.pickAndUploadImage(event.brandId);
      
      if (imageUrls != null) {
        emit(CreateBrandFormImageUrlsUpdated(
          fullImageUrl: imageUrls['brandLogoImageFullUrl']!,
          croppedImageUrl: imageUrls['brandLogoImageCroppedUrl']!,
        ));
      } else {
        emit(CreateBrandFormImageUploadFailed("Image selection was canceled."));
      }
    } catch (error) {
      emit(CreateBrandFormImageUploadFailed("Failed to upload image: $error"));
    }
  }

  Future<void> _onSubmitCreateBrandForm(
    SubmitCreateBrandForm event,
    Emitter<CreateBrandFormState> emit,
  ) async {
    try {
      emit(CreateBrandFormLoading());
      await brandRepository.submitBrand(event.brand);
      emit(CreateBrandFormSuccess());
    } catch (error) {
      emit(CreateBrandFormFailure("Failed to create brand: $error"));
    }
  }
}
