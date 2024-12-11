import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/create_brand/blocs/create_brand_form_bloc.dart';
import 'package:organizer_app/create_brand/blocs/create_brand_form_state.dart';
import 'package:organizer_app/create_brand/brand_image_uploader_service.dart';
import 'package:organizer_app/create_brand/widgets/create_brand_form.dart';
import 'package:shared/repositories/brand_repository.dart';
import 'package:shared/repositories/user_repository.dart';

class CreateBrandScreen extends StatelessWidget {
  const CreateBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Resolve dependencies from GetIt for local injection
    final brandRepository = GetIt.instance<BrandRepository>();
    final brandImageUploaderService = GetIt.instance<BrandImageUploaderService>();
    final userRepository = GetIt.instance<UserRepository>();

    return BlocProvider<CreateBrandFormBloc>(
      create: (_) => CreateBrandFormBloc(
        brandRepository: brandRepository,
        brandImageUploaderService: brandImageUploaderService,
        userRepository: userRepository,
      ),
      child: BlocListener<CreateBrandFormBloc, CreateBrandFormState>(
        listener: (context, state) {
          if (state is CreateBrandFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Brand created successfully!')),
            );
            context.pop();
            // Navigate to the profile page or another desired screen
          } else if (state is CreateBrandFormFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Create Brand'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CreateBrandForm(
                brandImageUploaderService: brandImageUploaderService,
              ),
          ),
        ),
      ),
    );
  }
}