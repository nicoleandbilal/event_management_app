import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final Function(TimeOfDay) onTimePicked;

  const CustomTimePicker({required this.onTimePicked, super.key});

  @override
  CustomTimePickerState createState() => CustomTimePickerState();
}

class CustomTimePickerState extends State<CustomTimePicker> {
  int selectedHour = 0;
  int selectedMinute = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Hour Dropdown
        Expanded(
          child: DropdownButtonFormField<int>(
            value: selectedHour,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            ),
            items: List.generate(24, (index) {
              return DropdownMenuItem(
                value: index,
                child: Text(
                  index.toString().padLeft(2, '0'), // Pad the hour with 0
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }),
            onChanged: (value) {
              setState(() {
                selectedHour = value ?? 0;
              });
              widget.onTimePicked(TimeOfDay(hour: selectedHour, minute: selectedMinute));
            },
            hint: const Text('Hour'),
          ),
        ),
        const SizedBox(width: 10),
        // Minute Dropdown
        Expanded(
          child: DropdownButtonFormField<int>(
            value: selectedMinute,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            ),
            items: List.generate(60, (index) {
              return DropdownMenuItem(
                value: index,
                child: Text(
                  index.toString().padLeft(2, '0'), // Pad the minute with 0
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }),
            onChanged: (value) {
              setState(() {
                selectedMinute = value ?? 0;
              });
              widget.onTimePicked(TimeOfDay(hour: selectedHour, minute: selectedMinute));
            },
            hint: const Text('Minute'),
          ),
        ),
      ],
    );
  }
}
