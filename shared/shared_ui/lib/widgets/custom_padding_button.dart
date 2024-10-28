// custom_padding_button.dart

import 'package:flutter/material.dart';

class CustomPaddingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final ButtonStyle? style;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Size? minimumSize;

  const CustomPaddingButton({
    super.key,
    required this.onPressed,
    this.label = 'Label',
    this.style,
    this.foregroundColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
    this.borderRadius = 3.0,
    this.minimumSize = const Size(double.infinity, 40),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style ??
          ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            minimumSize: minimumSize,
            padding: padding,
          ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
