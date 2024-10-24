import 'package:intl/intl.dart';

class DateFormatter {
  // Function to add ordinal suffix to the day
  static String _getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  // Main function to format date as: Wed 21st Jun
  static String formatDate(DateTime dateTime) {
    String dayWithSuffix = _getDayWithSuffix(dateTime.day);
    String formattedDate = DateFormat('EEE').format(dateTime); // Day of the week
    String month = DateFormat('MMM').format(dateTime);         // Month abbreviation   
 // Return formatted date
    return '$formattedDate $dayWithSuffix $month'; 
  }
}
