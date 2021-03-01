import 'dart:math';

extension RandomExtension on Random {
  /// Obtains the next random double, scaled to fall between start and end.
  /// Start or end can be greater. If only start is specified, returns a
  /// number between 0 and start.
  double nextInRange(double start, [double end = 0]) =>
      start + nextDouble() * (end - start);

  /// Obtains the next random bool and returns either 1 or -1.
  int nextSign() => nextBool() ? 1 : -1;

  /// Obtains the next random double and returns true if it is less than
  /// or equal to probability.
  bool nextChance(double probability) => nextDouble() <= probability;
}
