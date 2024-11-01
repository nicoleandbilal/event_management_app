// create_brand_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organizer_app/create_brand_new/blocs/create_brand_form_bloc.dart';
import 'package:organizer_app/create_brand_new/blocs/create_brand_form_state.dart';
import 'package:organizer_app/create_brand_new/brand_image_upload_service.dart';
import 'package:organizer_app/create_brand_new/create_brand_form.dart';
import 'package:shared/repositories/brand_repository.dart';
import 'package:shared/repositories/image_repository.dart';

class CreateBrandScreen extends StatelessWidget {
  const CreateBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BrandRepository>(
          create: (context) => BrandRepository(
            firestore: FirebaseFirestore.instance,
          ),
        ),
        RepositoryProvider<ImageRepository>(
          create: (context) => ImageRepository(
            storage: FirebaseStorage.instance,
          ),
        ),
        RepositoryProvider<ImageUploadService>(
          create: (context) => ImageUploadService(
            RepositoryProvider.of<ImageRepository>(context),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => CreateBrandFormBloc(
          RepositoryProvider.of<BrandRepository>(context),
          RepositoryProvider.of<ImageUploadService>(context),
        ),
        child: BlocListener<CreateBrandFormBloc, CreateBrandFormState>(
          listener: (context, state) {
            if (state is CreateBrandFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Brand created successfully!')),
              );
              context.go('/profile');
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
            body: const Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: CreateBrandForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
