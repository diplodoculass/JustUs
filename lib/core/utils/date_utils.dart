import 'package:intl/intl.dart';

/// Date utilities for the JustUs app.
class AppDateUtils {
  AppDateUtils._();

  /// Format date as "MMM d, yyyy" (e.g., "Apr 2, 2026")
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Format date as "MMMM d, yyyy" (e.g., "April 2, 2026")
  static String formatDateFull(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  /// Format as relative time (e.g., "2h ago", "3d ago", "Just now")
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  /// Calculate days between two dates
  static int daysBetween(DateTime start, DateTime end) {
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    return endDate.difference(startDate).inDays;
  }

  /// Days together since relationship start
  static int daysTogether(DateTime startDate) {
    return daysBetween(startDate, DateTime.now());
  }

  /// Days until next occurrence of a date (anniversary, milestone)
  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    var nextOccurrence = DateTime(now.year, date.month, date.day);
    if (nextOccurrence.isBefore(now) ||
        nextOccurrence.isAtSameMomentAs(now)) {
      nextOccurrence = DateTime(now.year + 1, date.month, date.day);
    }
    return daysBetween(now, nextOccurrence);
  }

  /// Days since a past date
  static int daysSince(DateTime date) {
    return daysBetween(date, DateTime.now());
  }

  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if a date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  /// Get week label (e.g., "Week of Apr 1")
  static String weekLabel(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return 'Week of ${DateFormat('MMM d').format(startOfWeek)}';
  }

  /// Format duration in seconds to "Xm Xs" or "Xs"
  static String formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes}m ${secs}s';
  }

  /// Get the date string for today's prompt lookup (yyyy-MM-dd)
  static String todayKey() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  /// Get month/year header for memory sections
  static String monthYearHeader(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  /// Get next relationship milestone label
  static String nextMilestone(DateTime startDate) {
    final days = daysTogether(startDate);
    final milestones = [30, 60, 90, 100, 180, 365, 500, 730, 1000, 1095, 1461];

    for (final m in milestones) {
      if (days < m) {
        final remaining = m - days;
        if (m == 365) return '$remaining d to 1 year';
        if (m == 730) return '$remaining d to 2 years';
        if (m == 1095) return '$remaining d to 3 years';
        if (m == 1461) return '$remaining d to 4 years';
        return '$remaining d to $m days';
      }
    }

    // Past all predefined milestones, show next anniversary
    final years = days ~/ 365;
    final nextAnniversaryDays = (years + 1) * 365;
    return '${nextAnniversaryDays - days} d to ${years + 1} years';
  }
}
