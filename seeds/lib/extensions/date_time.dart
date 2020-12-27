
extension DateTimeExtension on DateTime {
  // Calculates the days until (pos) or since (neg) the given date. Days begin
  // at midnight of the local timezone.
  int daysUntil(DateTime date) {
    if (this == null || date == null) return null;

    // Convert dates to match local timezone
    var past = toLocal();
    var future = date.toLocal();

    // Remove time component to get date
    past = DateTime(past.year, past.month, past.day);
    future = DateTime(future.year, future.month, future.day);

    // Return the difference in days
    return future.difference(past).inDays;
  }
}
