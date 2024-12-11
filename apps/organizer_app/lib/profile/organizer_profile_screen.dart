import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/repositories/brand_repository.dart';
import 'package:shared/widgets/custom_padding_button.dart';

class OrganizerProfileScreen extends StatelessWidget {
  const OrganizerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandRepository = GetIt.instance<BrandRepository>(); // Fetch BrandRepository from GetIt

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomPaddingButton(
            onPressed: () {
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