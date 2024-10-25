// custom_input_box.dart

import 'package:flutter/material.dart';

// Reusable CustomInputBox widget for consistent input styling
class CustomInputBox extends StatelessWidget {
  final Widget child;
  final double height;
  final EdgeInsets padding;
  final bool isDropdown;
  final Function()? onTap; // Added onTap for click behavior

  const CustomInputBox({
    super.key,
    required this.child,
    this.height = 50.0,  // Default height for inputs
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.isDropdown = false,  // Default to false unless it's a dropdown
    this.onTap,  // Added onTap for date/time picker or other interaction
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(  // GestureDetector allows us to capture tap events
      onTap: onTap,  // Call the passed onTap function when the container is tapped
      child: Container(
        height: height,  // Apply consistent height
        padding: padding,  // Padding around the content
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500),  // Border style
          borderRadius: BorderRadius.circular(8),  // Rounded corners
        ),
        child: Center(
          child: isDropdown 
              ? child  // For dropdowns, don't center-align text vertically
              : Align(alignment: Alignment.centerLeft, child: child),  // Align text inputs to the left
        ),
      ),
    );
  }
}
