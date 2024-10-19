// create_event_date_picker.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared/widgets/input_box.dart';

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

  // Function to handle the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      onDatePicked(pickedDate);
    }
  }

  // Function to handle the time picker
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
            // Date picker
            Expanded(
              child: InputBox(
                onTap: () => _selectDate(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date == null
                          ? 'Choose date' // Placeholder
                          : DateFormat('MM/dd/yyyy').format(date!),
                      style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                          color: date == null ? Colors.grey : Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Time picker
            Expanded(
              child: InputBox(
                onTap: () => _selectTime(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      time == null
                          ? 'Choose time' // Placeholder
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
              ),
            ),
          ],
        ),
      ],
    );
  }
}
