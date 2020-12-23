import 'dart:math';
import 'package:flutter/material.dart';

// The home of miscellaneous functions
extension DateTimeExtension on DateTime {
  // Return true if present is on a future date from past
  @Deprecated('Please use daysUntil instead')
  bool isFutureDay(DateTime present) {
    // If no present date is provided, it is not the future
    if (present == null) {
      return false;
    } else if (this == null) {
      return true;
    } else if (present.year > year) {
      return true;
    } else if (present.year == year) {
      // Then if the present month is later, it is the future
      if (present.month > month) {
        return true;
      } else if (present.month == month) {
        // Then if the present day is later, it is the future
        if (present.day > day) return true;
      }
    }

    // Otherwise, the present is not a future date
    return false;
  }

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

String enumToString<T>(T value) => value.toString().split('.').last;

extension StringExtension on String {
  String capitalize() {
    if (length > 1) {
      return '${this[0].toUpperCase()}${substring(1)}';
    } else if (length == 1) {
      return '${this[0].toUpperCase()}';
    } else {
      return '';
    }
  }

  // Capitalizes and adds spaces between existing capital letters
  String toTitle() =>
      ((length > 0) ? this[0].toUpperCase() : '') +
      ((length > 1)
          ? substring(1).characters.map((c) => c.isCapital ? ' $c' : c).join()
          : '');

  // Converts a string to an enum value
  T toEnum<T>(List<T> values, {T Function() orElse}) => values.firstWhere(
        (val) => val.toString().split('.').last.toLowerCase() == toLowerCase(),
        orElse: orElse,
      );

  int get wordCount {
    final containsLetter = RegExp(r'.*[a-zA-Z].*');

    var words = split(' ');
    words.removeWhere((word) => !containsLetter.hasMatch(word));

    return words.length;
  }

  bool get isCapital => this == toUpperCase();
  bool get isNumeric => double.tryParse(this ?? '') != null;
}

extension ListExtension<T> on List<T> {
  static final Random _random = Random();

  // Returns a random item from the list
  T randomItem() => length > 0 ? this[_random.nextInt(length)] : null;
}
