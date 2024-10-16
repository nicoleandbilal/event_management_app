import 'package:flutter/material.dart';

class CreateEventImageUpload extends StatelessWidget {
  final TextEditingController urlController;

  const CreateEventImageUpload({required this.urlController, super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Image',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 8),
        // Implement image upload logic here
      ],
    );
  }
}
