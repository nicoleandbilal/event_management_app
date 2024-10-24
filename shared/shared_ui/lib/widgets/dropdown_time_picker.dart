import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared/widgets/custom_input_box.dart';

class CustomDropdownTimePicker extends StatefulWidget {
  final TimeOfDay? time;
  final Function(TimeOfDay) onTimePicked;

  const CustomDropdownTimePicker({
    required this.time,
    required this.onTimePicked,
    super.key,
  });

  @override
  _CustomDropdownTimePickerState createState() =>
      _CustomDropdownTimePickerState();
}

class _CustomDropdownTimePickerState extends State<CustomDropdownTimePicker> {
  int? _selectedHour;
  int? _selectedMinute;

  @override
  void initState() {
    super.initState();
    if (widget.time != null) {
      _selectedHour = widget.time!.hour;
      _selectedMinute = widget.time!.minute;
    }
  }

  List<DropdownMenuItem<int>> _buildDropdownItems(int range, {int step = 1}) {
    return List.generate((range / step).round(), (index) {
      final value = (index * step).toString().padLeft(2, '0'); // Format as "00"
      return DropdownMenuItem<int>(
        value: index * step,
        child: Text(
          value,
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    });
  }

  void _onTimeChanged() {
    if (_selectedHour != null && _selectedMinute != null) {
      final pickedTime = TimeOfDay(hour: _selectedHour!, minute: _selectedMinute!);
      widget.onTimePicked(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hour dropdown inside its own CustomInputBox
        Expanded(
          child: CustomInputBox(
            height: 50,
            child: DropdownButton<int>(
              value: _selectedHour,
              hint: const Text('00'),
              items: _buildDropdownItems(24), // Hours range
              onChanged: (value) {
                setState(() {
                  _selectedHour = value!;
                });
                _onTimeChanged();
              },
              underline: const SizedBox.shrink(), // Remove underline
              isExpanded: true, // Ensures the dropdown takes the whole space
            ),
          ),
        ),
        // Colon separator
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(':'),
        ),
        // Minute dropdown inside its own CustomInputBox with 5-minute increments
        Expanded(
          child: CustomInputBox(
            height: 50,
            child: DropdownButton<int>(
              value: _selectedMinute,
              hint: const Text('00'),
              items: _buildDropdownItems(60, step: 5), // Minutes in 5-minute steps
              onChanged: (value) {
                setState(() {
                  _selectedMinute = value!;
                });
                _onTimeChanged();
              },
              underline: const SizedBox.shrink(), // Remove underline
              isExpanded: true, // Ensures the dropdown takes the whole space
            ),
          ),
        ),
      ],
    );
  }
}
