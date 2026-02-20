import 'package:intl/intl.dart';

/// Utility class for formatting dates
class DateFormatter {
  DateFormatter._();

  static final DateFormat _fullFormat = DateFormat('MMMM dd, yyyy');
  static final DateFormat _shortFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');
  static final DateFormat _dateTimeFormat = DateFormat('MMM dd, yyyy • hh:mm a');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');

  /// Format as full date (e.g., January 15, 2024)
  static String formatFull(DateTime date) {
    return _fullFormat.format(date);
  }

  /// Format as short date (e.g., Jan 15, 2024)
  static String formatShort(DateTime date) {
    return _shortFormat.format(date);
  }

  /// Format as time only (e.g., 02:30 PM)
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Format as date and time (e.g., Jan 15, 2024 • 02:30 PM)
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  /// Format as month and year (e.g., January 2024)
  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  /// Get relative time (e.g., "2 hours ago", "Yesterday")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatShort(date);
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
}
