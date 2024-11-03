part of 'choose_brand_dropdown_bloc.dart';

abstract class ChooseBrandDropdownEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUserBrands extends ChooseBrandDropdownEvent {
  final List<String> brandIds;

  LoadUserBrands(this.brandIds);

  @override
  List<Object> get props => [brandIds];
}
