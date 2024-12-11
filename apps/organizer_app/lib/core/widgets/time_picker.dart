// custom_time_picker.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared/widgets/custom_input_box.dart';

class CustomTimePicker extends StatelessWidget {
  final TimeOfDay? time;
  final Function(TimeOfDay) onTimePicked;

  const CustomTimePicker({
    required this.time,
    required this.onTimePicked,
    super.key,
  });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      onTimePicked(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputBox(
      height: 50,
      onTap: () => _selectTime(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time == null
                ? 'Choose time'
                : time!.format(context),
            style: GoogleFonts.raleway(
              textStyle: TextStyle(
                color: time == null ? Colors.grey : Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
          const Icon(Icons.access_time),
        ],
      ),
    );
  }
}
