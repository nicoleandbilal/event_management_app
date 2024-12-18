import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_brand/blocs/create_brand_form_event.dart';
import 'package:organizer_app/create_brand/blocs/create_brand_form_state.dart';
import 'package:organizer_app/create_brand/brand_image_uploader_service.dart';
import 'package:shared/repositories/brand_repository.dart';
import 'package:shared/repositories/user_repository.dart';

class CreateBrandFormBloc extends Bloc<CreateBrandFormEvent, CreateBrandFormState> {
  final BrandRepository brandRepository;
  final BrandImageUploaderService brandImageUploaderService;
  final UserRepository userRepository;

  CreateBrandFormBloc({
    required this.brandRepository,
    required this.brandImageUploaderService,
    required this.userRepository,
  }) : super(CreateBrandFormInitial()) {
    on<CreateDraftBrand>(_onCreateDraftBrand);
    on<SubmitCreateBrandForm>(_onSubmitCreateBrandForm);
    on<UpdateImageUrls>(_onUpdateImageUrls);
    on<DeleteImageUrls>(_onDeleteImageUrls);
  }

  Future<void> _onCreateDraftBrand(
    CreateDraftBrand event,
    Emitter<CreateBrandFormState> emit,
  ) async {
    try {
      final brandId = await brandRepository.createDraftBrand(event.brand);

      // After brand creation, add the brand ID to the user document
      await userRepository.addBrandToUser(
        userId: event.brand.userId,
        brandId: brandId,
      );

      emit(CreateBrandFormDraftCreated(brandId: brandId));
    } catch (error) {
      emit(CreateBrandFormFailure(error.toString()));
    }
  }

  Future<void> _onSubmitCreateBrandForm(
    SubmitCreateBrandForm event,
    Emitter<CreateBrandFormState> emit,
  ) async {
    emit(CreateBrandFormLoading());
    try {
      await brandRepository.submitBrand(event.brand);

      // After brand submission, ensure the brand ID is also added to the user document
      await userRepository.addBrandToUser(
        userId: event.brand.userId,
        brandId: event.brand.brandId,
      );

      emit(CreateBrandFormSuccess());
    } catch (error) {
      emit(CreateBrandFormFailure(error.toString()));
    }
  }

  Future<void> _onUpdateImageUrls(
    UpdateImageUrls event,
    Emitter<CreateBrandFormState> emit,
  ) async {
    emit(CreateBrandFormImageUploading());
    emit(CreateBrandFormImageUrlsUpdated(
      fullImageUrl: event.fullImageUrl,
      croppedImageUrl: event.croppedImageUrl,
    ));
  }

  void _onDeleteImageUrls(
    DeleteImageUrls event, 
    Emitter<CreateBrandFormState> emit) {
    emit(const CreateBrandFormImageUrlsUpdated());
  }
}
