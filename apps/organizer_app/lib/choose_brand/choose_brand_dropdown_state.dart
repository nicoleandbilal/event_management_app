part of 'choose_brand_dropdown_bloc.dart';

class ChooseBrandDropdownState extends Equatable {
  final List<Brand> brands; // List of brands to display
  final bool loading; // Loading indicator
  final String? error; // Error message, if any

  const ChooseBrandDropdownState({
    required this.brands,
    required this.loading,
    this.error,
  });

  factory ChooseBrandDropdownState.initial() {
    return const ChooseBrandDropdownState(
      brands: [],
      loading: false,
    );
  }

  // CopyWith for immutability and convenient state updates
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
