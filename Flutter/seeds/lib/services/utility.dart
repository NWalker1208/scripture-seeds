
bool isFutureDay(DateTime past, DateTime present) {
  return present.year > past.year || (
    present.year == past.year && (present.month > past.month || (
      present.month == past.month && present.day > past.day
    ))
  );
}
