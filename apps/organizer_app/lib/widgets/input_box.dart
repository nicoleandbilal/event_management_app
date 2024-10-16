import 'package:flutter/material.dart';

// Custom reusable InputBox widget for text fields, date, and time pickers
class InputBox extends StatelessWidget {
  final Widget child;
  final Function()? onTap;

  const InputBox({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,  // For date/time pickers, trigger the picker dialog
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        height: 50, // Set a fixed height for consistent appearance
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center( // Center the child for consistent alignment
          child: child,
        ),
      ),
    );
  }
}
