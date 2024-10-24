import 'package:intl/intl.dart';

class TimeFormatter {
  // Main function to format time as 18:00
  static String formatTime(DateTime dateTime) {
    return DateFormat('kk:mm').format(dateTime); // Return formatted time
  }
}
