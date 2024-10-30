import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_brand/bloc/create_brand_form_bloc.dart';
import 'package:organizer_app/create_brand/bloc/create_brand_form_state.dart';
import 'package:organizer_app/create_brand/brand_logo_image_repository.dart';
import 'package:organizer_app/create_brand/create_brand_form.dart';
import 'package:organizer_app/create_brand/repositories/brand_logo_upload_service.dart';

class CreateBrandScreen extends StatefulWidget {
  const CreateBrandScreen({super.key});

  @override
  CreateBrandScreenState createState() => CreateBrandScreenState();
}

class CreateBrandScreenState extends State<CreateBrandScreen> {
  bool _isDialogVisible = false;

  void _showLoadingDialog(BuildContext context) {
    if (!_isDialogVisible) {
      _isDialogVisible = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }
  }

  void _hideLoadingDialog(BuildContext context) {
    if (_isDialogVisible) {
      Navigator.of(context).pop();
      _isDialogVisible = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandLogoImageRepository = BrandLogoImageRepository();
    final uploadService = BrandLogoUploadService(brandLogoImageRepository);

    return BlocProvider(
      create: (context) => CreateBrandFormBloc(
        brandRepository: RepositoryProvider.of(context),
        uploadService: uploadService,
      ),
      child: BlocListener<CreateBrandFormBloc, CreateBrandFormState>(
        listener: (context, state) {
          print("State changed to: $state"); // Debugging statement

          if (state is CreateBrandFormImageUploading) {
            _showLoadingDialog(context);
          } else if (state is CreateBrandFormImageUrlsUpdated || state is CreateBrandFormImageUploadFailed) {
            _hideLoadingDialog(context);

            if (state is CreateBrandFormImageUploadFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Upload error: ${state.errorMessage}')),
              );
            }
          } else if (state is CreateBrandFormSuccess) {
            _hideLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Brand created successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is CreateBrandFormFailure) {
            _hideLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: CreateBrandForm(
          uploadService: uploadService,
        ),
      ),
    );
  }
}
