// create_brand_form.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_brand_new/blocs/create_brand_form_bloc.dart';
import 'package:organizer_app/create_brand_new/blocs/create_brand_form_event.dart';
import 'package:organizer_app/create_brand_new/blocs/create_brand_form_state.dart';
import 'package:organizer_app/create_brand_new/create_brand_image_uploader.dart';
import 'package:shared/models/brand_model.dart';
import 'package:shared/widgets/custom_input_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/authentication/auth/auth_service.dart';

class CreateBrandForm extends StatefulWidget {
  const CreateBrandForm({super.key});

  @override
  _CreateBrandFormState createState() => _CreateBrandFormState();
}

class _CreateBrandFormState extends State<CreateBrandForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _brandDescriptionController = TextEditingController();
  
  String? _selectedCategory;
  String? brandId;

  @override
  void initState() {
    super.initState();
    _initializeDraftBrand();
  }

  void _initializeDraftBrand() async {
    final userId = context.read<AuthService>().getCurrentUserId();

    if (userId != null) {
      final draftBrand = Brand(
        brandId: '', 
        userId: userId,
        brandName: '',
        brandLogoImageFullUrl: null,
        brandLogoImageCroppedUrl: null,
        category: 'Other',
        status: 'draft',
        brandDescription: '',
        teamMembers: [userId],
        createdAt: Timestamp.now(),
        updatedAt: null,
      );

      context.read<CreateBrandFormBloc>().add(CreateDraftBrand(draftBrand));
    }
  }

  void _createBrand(BuildContext context, String? fullImageUrl, String? croppedImageUrl) {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        _showErrorDialog('Please select a brand category');
        return;
      }

      if (brandId != null) {
        final updatedBrand = Brand(
          brandId: brandId!,
          userId: context.read<AuthService>().getCurrentUserId()!,
          brandName: _brandNameController.text,
          brandLogoImageFullUrl: fullImageUrl,
          brandLogoImageCroppedUrl: croppedImageUrl,
          category: _selectedCategory!,
          status: 'live',
          brandDescription: _brandDescriptionController.text,
          teamMembers: [context.read<AuthService>().getCurrentUserId()!],
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        );

        context.read<CreateBrandFormBloc>().add(SubmitCreateBrandForm(updatedBrand));
      }
    }
  }

  void _showErrorDialog(String message) {
    context.push('/error', extra: {'message': message});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBrandFormBloc, CreateBrandFormState>(
      builder: (context, state) {
        String? fullImageUrl;
        String? croppedImageUrl;

        if (state is CreateBrandFormImageUrlsUpdated) {
          fullImageUrl = state.fullImageUrl;
          croppedImageUrl = state.croppedImageUrl;
        } else if (state is CreateBrandFormDraftCreated) {
          brandId = state.brandId;
        }

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextInput(
                  'Brand Name',
                  'Enter brand name',
                  _brandNameController,
                  (value) => value == null || value.isEmpty ? 'Please enter brand name' : null,
                ),
                const SizedBox(height: 16),
                CreateBrandImageUpload(
                  imageUploadService: context.read(),
                  brandId: brandId ?? '',
                ),
                const SizedBox(height: 16),
                _buildTextInput(
                  'Event Description',
                  'Enter event description',
                  _brandDescriptionController,
                  (value) => value == null || value.isEmpty ? 'Please enter event description' : null,
                ),
                const SizedBox(height: 16),
                _buildCategoryDropdown(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => _createBrand(context, fullImageUrl, croppedImageUrl),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      backgroundColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Create Brand',
                      style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        CustomInputBox(
          isDropdown: true,
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            hint: const Text('Select Category'),
            items: <String>['Entertainment', 'Corporate', 'Non-Profit', 'Startup', 'Other']
                .map((String value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (newValue) => setState(() => _selectedCategory = newValue),
            decoration: const InputDecoration(border: InputBorder.none),
            validator: (value) => value == null || value.isEmpty ? 'Please select a category' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTextInput(
    String label,
    String placeholder,
    TextEditingController controller,
    String? Function(String?) validator,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        CustomInputBox(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.primary),
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
