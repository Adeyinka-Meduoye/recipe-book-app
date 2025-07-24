import 'package:intl/intl.dart';

/// Utility functions for the Recipe Book app.
class Helpers {
  /// Formats a duration in minutes to a human-readable string (e.g., "1 hr 30 min").
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '$hours hr';
    }
    return '$hours hr $remainingMinutes min';
  }

  /// Capitalizes the first letter of a string (e.g., "spaghetti" -> "Spaghetti").
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Validates a search query by trimming and checking for non-empty content.
  static bool isValidSearchQuery(String query) {
    final trimmedQuery = query.trim();
    return trimmedQuery.isNotEmpty && trimmedQuery.length >= 2;
  }

  /// Formats a date to a readable string (e.g., "Jan 24, 2025").
  static String formatDate(DateTime date) {
    return DateFormat.yMMMEd().format(date);
  }

  /// Converts a double to a formatted string with a specified number of decimal places.
  static String formatQuantity(double quantity, {int decimalPlaces = 1}) {
    return quantity.toStringAsFixed(decimalPlaces);
  }
}