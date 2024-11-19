// custom_date_picker.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared/widgets/custom_input_box.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime? date;
  final Function(DateTime) onDatePicked;

  const CustomDatePicker({
    required this.date,
    required this.onDatePicked,
    super.key,
  });

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

  @override
  Widget build(BuildContext context) {
    return CustomInputBox(
      height: 50,
      onTap: () => _selectDate(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date == null
                ? 'Choose date'
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
    );
  }
}
