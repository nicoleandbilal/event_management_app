import 'package:shared/utils/date_formatter.dart';
import 'package:shared/utils/time_formatter.dart';

class DateTimeFormatter {
  // Combines date and time into a single formatted string
  static String formatDateTime(DateTime dateTime) {
    String formattedDate = DateFormatter.formatDate(dateTime);
    String formattedTime = TimeFormatter.formatTime(dateTime);
    return '$formattedDate at $formattedTime';  // Combine date and time
  }
}
