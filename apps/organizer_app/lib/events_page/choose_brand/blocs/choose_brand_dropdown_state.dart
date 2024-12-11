part of 'choose_brand_dropdown_bloc.dart';

class ChooseBrandDropdownState extends Equatable {
  final List<Brand> brands;
  final bool loading;
  final String? error;

  ChooseBrandDropdownState({
    required this.brands,
    required this.loading,
    required this.error,
  });

  factory ChooseBrandDropdownState.initial() {
    return ChooseBrandDropdownState(
      brands: [],
      loading: false,
      error: null,
    );
  }

  ChooseBrandDropdownState copyWith({
    List<Brand>? brands,
    bool? loading,
    String? error,
  }) {
    return ChooseBrandDropdownState(
      brands: brands ?? this.brands,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [brands, loading, error];
}