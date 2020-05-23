
bool isFutureDay(DateTime past, DateTime present) {
  return past == null || present.year > past.year || (
    present.year == past.year && (present.month > past.month || (
      present.month == past.month && present.day > past.day
    ))
  );
}
