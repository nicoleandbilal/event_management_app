import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:organizer_app/events_page/choose_brand/blocs/choose_brand_dropdown_bloc.dart';
import 'package:shared/authentication/auth/auth_service.dart';
import 'package:shared/widgets/custom_input_box.dart';

class ChooseBrandDropdown extends StatefulWidget {
  final void Function(List<String> brandIds) onBrandSelected;

  const ChooseBrandDropdown({
    super.key,
    required this.onBrandSelected,
  });

  @override
  _ChooseBrandDropdownState createState() => _ChooseBrandDropdownState();
}

class _ChooseBrandDropdownState extends State<ChooseBrandDropdown> {
  String? _selectedBrand;
  List<String> userBrandIds = [];

  @override
  void initState() {
    super.initState();
    _loadUserBrands();
  }

  Future<void> _loadUserBrands() async {
    final authService = GetIt.I<AuthService>();
    final userId = authService.getCurrentUserId();

    if (userId == null) {
      // User not authenticated, handle gracefully
      context.read<ChooseBrandDropdownBloc>().add(LoadUserBrands([]));
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final userData = userDoc.data();

      // If no brandIds are found, dispatch empty event
      final rawBrandIds = userData?['brandIds'];
      if (rawBrandIds == null) {
        context.read<ChooseBrandDropdownBloc>().add(LoadUserBrands([]));
        return;
      }

      userBrandIds = List<String>.from(rawBrandIds).where((id) => id.trim().isNotEmpty).toList();
      context.read<ChooseBrandDropdownBloc>().add(LoadUserBrands(userBrandIds));
    } catch (e) {
      // If an error occurs, log it and provide empty list to the bloc
      print("Error loading user brands: $e");
      context.read<ChooseBrandDropdownBloc>().add(LoadUserBrands([]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Brand',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 8),
        BlocBuilder<ChooseBrandDropdownBloc, ChooseBrandDropdownState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return Center(
                child: Text(
                  'Error loading brands: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state.brands.isEmpty) {
              return const Text('No brands available.');
            }

            final allowedValues = ["all", ...state.brands.map((b) => b.brandId)];

            // Ensure the current _selectedBrand is valid
            if (_selectedBrand != null && !allowedValues.contains(_selectedBrand)) {
              _selectedBrand = "all";
            }

            return CustomInputBox(
              isDropdown: true,
              child: DropdownButtonFormField<String>(
                value: _selectedBrand,
                hint: const Text('Select Brand'),
                items: [
                  const DropdownMenuItem<String>(
                    value: "all",
                    child: Text("All Brands"),
                  ),
                  ...state.brands.map((brand) {
                    return DropdownMenuItem<String>(
                      value: brand.brandId,
                      child: Text(brand.brandName),
                    );
                  }),
                ],
                onChanged: (newValue) {
                  setState(() => _selectedBrand = newValue);

                  if (newValue == "all") {
                    // "All" selected, pass all brand IDs
                    widget.onBrandSelected(userBrandIds);
                  } else if (newValue != null) {
                    // A specific brand selected
                    widget.onBrandSelected([newValue]);
                  } else {
                    // newValue is null, which shouldn't happen if brand IDs are guaranteed
                    // Just log or do nothing
                    print("No brand selected due to null value.");
                  }
                },
                decoration: const InputDecoration(border: InputBorder.none),
                validator: (value) => value == null ? 'Please select a brand' : null,
              ),
            );
          },
        ),
      ],
    );
  }
}