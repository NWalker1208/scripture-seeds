import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// The home of miscellaneous functions

// Converts a string to an enum value
T stringToEnum<T>(List<T> values, String string) => values
    .firstWhere((val) => val.toString().contains(string), orElse: () => null);

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

  int get wordCount {
    final containsLetter = RegExp(r'.*[a-zA-Z].*');

    var words = split(' ');
    words.removeWhere((word) => !containsLetter.hasMatch(word));

    return words.length;
  }

  bool get isCapital => this == toUpperCase();
}

extension ListExtension<T> on List<T> {
  static final Random _random = Random();

  // Returns a random item from the list
  T randomItem() => length > 0 ? this[_random.nextInt(length)] : null;
}

int hitTestList(Offset position, List<GlobalKey> widgets) {
  for (var i = 0; i < widgets.length; i++) {
    var renderBox = widgets[i].currentContext.findRenderObject() as RenderBox;
    var localPosition = renderBox.globalToLocal(position);
    var result = BoxHitTestResult();

    if (renderBox.hitTest(result, position: localPosition)) return i;
  }

  return null;
}
