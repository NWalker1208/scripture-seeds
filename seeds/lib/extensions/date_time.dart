extension DateTimeExtension on DateTime {
  /// Returns the date component of this object (removes time).
  DateTime get date => DateTime(year, month, day);

  /// Calculates the number of days ago that this date occurred, relative to
  /// [DateTime.now]. If this date is in the future, the number is negative.
  int get daysAgo => DateTime.now().date.difference(date).inDays;
}
