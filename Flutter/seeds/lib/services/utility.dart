// The home of miscellaneous functions

extension DateTimeExtension on DateTime {
  // Return true if present is on a future date from past
  @Deprecated('Please use daysUntil instead')
  bool isFutureDay(DateTime present) {
    // If no present date is provided, it is not the future
    if (present == null)
      return false;
    // If no past date is provided, the present is the future
    else if (this == null)
      return true;
    // If the present year is later, it is the future
    else if (present.year > this.year)
      return true;

    // Otherwise, if the years are the same...
    else if (present.year == this.year) {
      // Then if the present month is later, it is the future
      if (present.month > this.month)
        return true;
      // Otherwise, if the months are the same...
      else if (present.month == this.month) {
        // Then if the present day is later, it is the future
        if (present.day > this.day)
          return true;
      }
    }

    // Otherwise, the present is not a future date
    return false;
  }

  // Calculates the days until (pos) or since (neg) the given date. Days begin
  // at midnight of the local timezone.
  int daysUntil(DateTime date) {
    if (this == null || date == null)
      return null;

    // Convert dates to match local timezone
    DateTime past = this.toLocal();
    DateTime future = date.toLocal();

    // Remove time component to get date
    past = DateTime(past.year, past.month, past.day);
    future = DateTime(future.year, future.month, future.day);

    // Return the difference in days
    return future.difference(past).inDays;
  }
}

extension StringExtension on String {
  String capitalize() {
    if (length > 1)
      return '${this[0].toUpperCase()}${this.substring(1)}';
    else if (length == 1)
      return '${this[0].toUpperCase()}';
    else
      return '';
  }
}
