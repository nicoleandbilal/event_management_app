// date_and_time_picker.dart
import 'package:flutter/material.dart';
import 'package:shared/widgets/date_picker.dart';
import 'package:shared/widgets/dropdown_time_picker.dart';

class CreateEventDatePicker extends StatelessWidget {
  final String label;
  final DateTime? date;
  final TimeOfDay? time;
  final Function(DateTime) onDatePicked;
  final Function(TimeOfDay) onTimePicked;

  const CreateEventDatePicker({
    required this.label,
    required this.date,
    required this.time,
    required this.onDatePicked,
    required this.onTimePicked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Use CustomDatePicker for the date selection
            Expanded(
              child: CustomDatePicker(
                date: date,
                onDatePicked: onDatePicked,
              ),
            ),
            const SizedBox(width: 10),
            // Use CustomTimePicker for the time selection
            Expanded(
              child: CustomDropdownTimePicker(
                time: time,
                onTimePicked: onTimePicked,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
