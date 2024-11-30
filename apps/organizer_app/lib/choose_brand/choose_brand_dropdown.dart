import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/authentication/auth/auth_service.dart';
import 'package:shared/widgets/custom_input_box.dart';
import 'choose_brand_dropdown_bloc.dart';

class ChooseBrandDropdown extends StatefulWidget {
  final void Function(List<String> brandIds) onBrandSelected; // List of brand IDs

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
    try {
      final userId = context.read<AuthService>().getCurrentUserId();
      
      if (userId == null) {
        throw Exception("User is not authenticated.");
      }

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        userBrandIds = List<String>.from(userDoc['brandIds'] ?? []);
        context.read<ChooseBrandDropdownBloc>().add(LoadUserBrands(userBrandIds));
      } else {
        throw Exception("User document does not exist.");
      }
    } catch (e) {
      print("Error in _loadUserBrands: $e");
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
              return const CircularProgressIndicator();
            } else if (state.error != null) {
              return Text('Error loading brands: ${state.error}');
            } else if (state.brands.isEmpty) {
              return const Text('No brands available.');
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
                  }).toList(),
                ],
                onChanged: (newValue) {
                  setState(() => _selectedBrand = newValue);
                  if (newValue == "all") {
                    widget.onBrandSelected(userBrandIds); // Pass all brand IDs
                  } else {
                    widget.onBrandSelected([newValue!]); // Pass selected brand ID
                  }
                },
                decoration: const InputDecoration(border: InputBorder.none),
                validator: (value) =>
                    value == null ? 'Please select a brand' : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
