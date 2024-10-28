// lib/utils/date_and_time_formatter.dart

import 'package:shared/utils/date_formatter.dart';
import 'package:shared/utils/time_formatter.dart';

class DateTimeFormatter {
  // Formats both start and end DateTimes, used in detailed views
  static String formatEventDateTime(DateTime startDateTime, DateTime endDateTime) {
    bool isSameDay = startDateTime.year == endDateTime.year &&
                     startDateTime.month == endDateTime.month &&
                     startDateTime.day == endDateTime.day;

    String formattedStartDate = DateFormatter.formatDate(startDateTime);
    String formattedStartTime = TimeFormatter.formatTime(startDateTime);
    String formattedEndTime = TimeFormatter.formatTime(endDateTime);

    if (isSameDay) {
      return '$formattedStartDate at $formattedStartTime - $formattedEndTime';
    } else {
      String formattedEndDate = DateFormatter.formatDate(endDateTime);
      return '$formattedStartDate at $formattedStartTime - $formattedEndDate at $formattedEndTime';
    }
  }

  // Formats only the start DateTime, used in event listings
  static String formatDateTime(DateTime dateTime) {
    String formattedDate = DateFormatter.formatDate(dateTime);
    String formattedTime = TimeFormatter.formatTime(dateTime);
    return '$formattedDate at $formattedTime';
  }
}
