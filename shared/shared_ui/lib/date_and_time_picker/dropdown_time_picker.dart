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
  int _selectedHour = 0;
  int _selectedMinute = 0;

  @override
  void initState() {
    super.initState();
    if (widget.time != null) {
      _selectedHour = widget.time!.hour.clamp(0, 23); // Ensure valid range
      _selectedMinute = widget.time!.minute - widget.time!.minute % 5; // Snap to nearest 5
    }
  }

  List<DropdownMenuItem<int>> _buildDropdownItems(int range, {int step = 1}) {
    return List.generate((range / step).ceil(), (index) {
      final value = (index * step);
      final formattedValue = value.toString().padLeft(2, '0'); // Format as "00"
      return DropdownMenuItem<int>(
        value: value,
        child: Text(
          formattedValue,
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
    final pickedTime = TimeOfDay(hour: _selectedHour, minute: _selectedMinute);
    widget.onTimePicked(pickedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hour dropdown
        Expanded(
          child: CustomInputBox(
            height: 50,
            child: DropdownButton<int>(
              value: _selectedHour,
              hint: const Text('00'),
              items: _buildDropdownItems(24), // Hours: 0 - 23
              onChanged: (value) {
                setState(() {
                  _selectedHour = value ?? 0;
                });
                _onTimeChanged();
              },
              underline: const SizedBox.shrink(),
              isExpanded: true,
            ),
          ),
        ),
        // Colon separator
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(':'),
        ),
        // Minute dropdown with 5-minute steps
        Expanded(
          child: CustomInputBox(
            height: 50,
            child: DropdownButton<int>(
              value: _selectedMinute,
              hint: const Text('00'),
              items: _buildDropdownItems(60, step: 5), // Minutes: 0, 5, 10, ..., 55
              onChanged: (value) {
                setState(() {
                  _selectedMinute = value ?? 0;
                });
                _onTimeChanged();
              },
              underline: const SizedBox.shrink(),
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }
}