import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/repositories/brand_repository.dart';
import 'package:shared/models/brand_model.dart';
import 'package:equatable/equatable.dart';

part 'choose_brand_dropdown_event.dart';
part 'choose_brand_dropdown_state.dart';

class ChooseBrandDropdownBloc extends Bloc<ChooseBrandDropdownEvent, ChooseBrandDropdownState> {
  final BrandRepository brandRepository;

  ChooseBrandDropdownBloc({required this.brandRepository}) : super(ChooseBrandDropdownState.initial()) {
    on<LoadUserBrands>(_onLoadUserBrands);
  }

  Future<void> _onLoadUserBrands(LoadUserBrands event, Emitter<ChooseBrandDropdownState> emit) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      if (event.brandIds.isEmpty) {
        emit(state.copyWith(error: 'No brands available for the user.', loading: false));
        return; // Stop further processing
      }

      final brands = await brandRepository.getBrandsByIds(event.brandIds);
      if (brands.isEmpty) {
        throw Exception("No brands found for the provided IDs.");
      }

      emit(state.copyWith(brands: brands, loading: false));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load brands: $e', loading: false));
    }
  }
}