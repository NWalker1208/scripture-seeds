/// Returns an iterable with ints from start (inclusive) to end (exclusive).
Iterable<int> range(int end, [int start = 0]) sync* {
  for (var i = start; i < end; i++) {
    yield i;
  }
}

extension IterableExtension<T> on Iterable<T> {
  /// Iterates over two iterables and executes function on each pair.
  /// Length will be the minimum of the lengths of the inputs.
  Iterable<U> zip<U>(
    Iterable<T> other,
    U Function(T, T) combine,
  ) sync* {
    final itA = iterator;
    final itB = other.iterator;

    while (itA.moveNext() && itB.moveNext()) {
      yield combine(itA.current, itB.current);
    }
  }
}
