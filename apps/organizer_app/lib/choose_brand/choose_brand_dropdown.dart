import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/authentication/auth/auth_service.dart';
import 'package:shared/widgets/custom_input_box.dart';
import 'choose_brand_dropdown_bloc.dart';

class ChooseBrandDropdown extends StatefulWidget {
  final void Function(String brandId) onBrandSelected;

  const ChooseBrandDropdown({
    super.key,
    required this.onBrandSelected,
  });

  @override
  _ChooseBrandDropdownState createState() => _ChooseBrandDropdownState();
}

class _ChooseBrandDropdownState extends State<ChooseBrandDropdown> {
  String? _selectedBrand;

  @override
  void initState() {
    super.initState();
    _loadUserBrands();
  }

Future<void> _loadUserBrands() async {
  try {
    // Retrieve the user ID from AuthService
    final userId = context.read<AuthService>().getCurrentUserId();
    print("User ID from AuthService: $userId");
    
    if (userId == null) {
      print("Error: User is not authenticated.");
      throw Exception("User is not authenticated.");
    }

    // Fetch the user's document from Firestore
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    print("Fetched user document: ${userDoc.data()}");

    // Check if the user document exists and extract brand IDs
    if (userDoc.exists) {
      final List<String> brandIds = List<String>.from(userDoc['brandIds'] ?? []);
      print("Extracted brand IDs: $brandIds");

      // Trigger loading brands by IDs in the BLoC
      context.read<ChooseBrandDropdownBloc>().add(LoadUserBrands(brandIds));
      print("LoadUserBrands event dispatched with brand IDs.");
    } else {
      print("Error: User document does not exist.");
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
              print('No brands found for user');
              return const Text('No brands available.');
            }

            print('Displaying ${state.brands.length} brands');
            return CustomInputBox(
              isDropdown: true,
              child: DropdownButtonFormField<String>(
                value: _selectedBrand,
                hint: const Text('Select Brand'),
                items: state.brands.map((brand) {
                  return DropdownMenuItem<String>(
                    value: brand.brandId,
                    child: Text(brand.brandName),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() => _selectedBrand = newValue);
                  if (newValue != null) {
                    widget.onBrandSelected(newValue);
                  }
                },
                decoration: const InputDecoration(border: InputBorder.none),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please select a brand' : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
