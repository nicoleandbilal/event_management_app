import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/repositories/brand_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/models/brand_model.dart';
import 'package:shared/authentication/auth/auth_service.dart';

part 'choose_brand_dropdown_event.dart';
part 'choose_brand_dropdown_state.dart';

class ChooseBrandDropdownBloc extends Bloc<ChooseBrandDropdownEvent, ChooseBrandDropdownState> {
  final BrandRepository brandRepository;
  final AuthService authService;

  ChooseBrandDropdownBloc({
    required this.brandRepository,
    required this.authService,
  }) : super(ChooseBrandDropdownState.initial()) {
    on<LoadUserBrands>(_onLoadUserBrands);
  }

  Future<void> _onLoadUserBrands(LoadUserBrands event, Emitter<ChooseBrandDropdownState> emit) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      print('Fetching brands for IDs: ${event.brandIds}');
      
      // Fetch the brands by IDs from the repository
      final brands = await brandRepository.getBrandsByIds(event.brandIds);

      print('Fetched brands: ${brands.map((b) => b.brandName).toList()}');

      emit(state.copyWith(brands: brands, loading: false));
    } catch (e) {
      print('Error in _onLoadUserBrands: $e');
      emit(state.copyWith(
        loading: false,
        error: 'Failed to load brands. Please try again.',
      ));
    }
  }
}
