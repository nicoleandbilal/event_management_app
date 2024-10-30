// profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/repositories/brand_repository.dart';
import 'package:shared/widgets/custom_padding_button.dart';

class OrganizerProfileScreen extends StatelessWidget {
  const OrganizerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Button at the top
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomPaddingButton(
            onPressed: () {
              // Ensure BrandRepository is available in the context
              final brandRepository = context.read<BrandRepository>();
              context.push(
                '/create_brand',
                extra: brandRepository,
              );
            },
            label: 'Create New Brand',
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey,
              minimumSize: const Size(double.infinity, 40),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const Divider(height: 1, color: Colors.grey),
      ],
    );
  }
}
