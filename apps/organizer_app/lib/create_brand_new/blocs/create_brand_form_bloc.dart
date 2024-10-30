import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_brand_new/blocs/create_brand_form_event.dart';
import 'package:organizer_app/create_brand_new/blocs/create_brand_form_state.dart';
import 'package:organizer_app/create_brand_new/brand_image_upload_service.dart';
import 'package:shared/repositories/brand_repository.dart';

class CreateBrandFormBloc extends Bloc<CreateBrandFormEvent, CreateBrandFormState> {
  final BrandRepository brandRepository;
  final ImageUploadService imageUploadService;

  CreateBrandFormBloc(
    this.brandRepository,
    this.imageUploadService) : super(CreateBrandFormInitial()) {
    on<SubmitCreateBrandForm>(_onSubmitCreateBrandForm);
    on<UpdateImageUrls>(_onUpdateImageUrls);
    on<DeleteImageUrls>(_onDeleteImageUrls);
  }

 Future<void> _onSubmitCreateBrandForm(
    SubmitCreateBrandForm brand, Emitter<CreateBrandFormState> emit
  ) async {
    emit(CreateBrandFormLoading());
    try {
      await brandRepository.submitBrand(brand.brand);
      emit(CreateBrandFormSuccess());
    } catch (error) {
      emit(CreateBrandFormFailure(error.toString()));
    }
  }

  Future<void> _onUpdateImageUrls(
    UpdateImageUrls brand, Emitter<CreateBrandFormState> emit
  ) async {
    emit(CreateBrandFormImageUploading());
    emit(CreateBrandFormImageUrlsUpdated(
      fullImageUrl: brand.fullImageUrl,
      croppedImageUrl: brand.croppedImageUrl,
    ));
  }

  void _onDeleteImageUrls(DeleteImageUrls brand, Emitter<CreateBrandFormState> emit) {
    emit(const CreateBrandFormImageUrlsUpdated());
  }
}
