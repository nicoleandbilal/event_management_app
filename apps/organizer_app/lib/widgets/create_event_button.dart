// create_event_button.dart

import 'package:flutter/material.dart';

class CreateEventButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final ButtonStyle? style;

  const CreateEventButton({
    super.key,
    required this.onPressed,
    this.label = 'Add Event',
    this.style,
  });

  @override
  Widget build(BuildContext context) {
      return ElevatedButton(
        style: style ??
            ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 40),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
        onPressed: onPressed,
        child: Text(label),
      );
    }
  }
