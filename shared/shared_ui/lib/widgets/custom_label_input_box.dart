import 'package:flutter/material.dart';

class CustomLabelInputBox extends StatelessWidget {
  final String labelText;
  final String validationMessage;
  final TextEditingController controller;
  final bool obscureText;

  const CustomLabelInputBox({
    super.key,
    required this.labelText,
    required this.validationMessage,
    required this.controller,
    this.obscureText = false, // Default value for obscureText is false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.fromLTRB(6, 4, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return validationMessage;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
