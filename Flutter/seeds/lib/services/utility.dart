// The home of miscellaneous functions

bool isFutureDay(DateTime past, DateTime present) {
  // If no present date is provided, it is not the future
  if (present == null)
    return false;
  // If no past date is provided, the present is the future
  else if (past == null)
    return true;
  // If the present year is later, it is the future
  else if (present.year > past.year)
    return true;

  // Otherwise, if the years are the same...
  else if (present.year == past.year) {
    // Then if the present month is later, it is the future
    if (present.month > past.month)
      return true;
    // Otherwise, if the months are the same...
    else if (present.month == past.month) {
      // Then if the present day is later, it is the future
      if (present.day > past.day)
        return true;
    }
  }

  // Otherwise, the present is not a future date
  return false;
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
