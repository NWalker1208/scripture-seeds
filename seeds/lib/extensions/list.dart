import 'dart:math';

extension ListExtension1<E extends T, T> on List<E> {
  static final Random _random = Random();

  // Returns a random item from the list
  E randomItem([Random random]) =>
      length > 0 ? this[(random ?? _random).nextInt(length)] : null;

  // Removes the items from start [inclusive] to
  // end [exclusive] and returns them as a list.
  List<E> removeSublist(int start, int end) {
    var sub = sublist(start, end);
    removeRange(start, end);
    return sub;
  }

  // Adds the items from this list to another list
  void addTo(List<T> other) => other.addAll(this);

  // Creates a list comparison
  ListComparison<E, V> compareTo<V>(
    Iterable<V> other, {
    Comparison<E, V> compare,
    Converter<V, E> convert,
  }) =>
      ListComparison(this, other, compare: compare, convert: convert);
}

typedef Comparison<T, S> = bool Function(T a, S b);
typedef Converter<T, S> = S Function(T a);

class ListComparison<E, V> {
  final List<E> oldItems;
  final List<E> newItems;
  final List<E> merged;

  ListComparison._({this.oldItems, this.newItems, this.merged});

  factory ListComparison(
    Iterable<E> oldList,
    Iterable<V> newList, {
    Comparison<E, V> compare,
    Converter<V, E> convert,
  }) {
    // Default comparison and conversion
    compare ??= ((e, v) => e == v);
    convert ??= ((v) => v as E);

    // Make copies of lists
    var a = oldList.toList();
    var b = newList.toList();

    // Stores elements from a that are not in b.
    var outgoing = <E>[];
    // Stores elements from b that are not in a.
    var incoming = <E>[];

    // Create list containing items from both a and b.
    // Items from a come first, unless their value is found
    // in b. If so, all values in b found before the value
    // of the item from a will be placed before the item from a.
    int index;
    var result = <E>[
      for (var item in a)
        if ((index = b.indexWhere((v) => compare(item, v))) != -1) ...[
          ...[
            // Takes the values between the start of b and the value of
            // the item from a. Removes those values from b and creates
            // new items from those values.
            for (var value in b.removeSublist(0, index + 1)..removeLast())
              convert(value)
          ]..addTo(incoming),
          item
        ] else
          ...[item]..addTo(outgoing),

      // Add remaining items
      ...[for (var value in b) convert(value)]..addTo(incoming)
    ];

    return ListComparison._(
      oldItems: outgoing,
      newItems: incoming,
      merged: result,
    );
  }
}
