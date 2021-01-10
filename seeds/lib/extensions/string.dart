import 'package:flutter/material.dart';

extension StringExtension on String {
  // Capitalizes the first letter of the string
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

  // Returns a String of only the enum's value (removes type prefix).
  static String fromEnum<T>(T value) => value.toString().split('.').last;

  // Converts a string to an enum value
  T toEnum<T>(List<T> values, {T Function() orElse}) => values.firstWhere(
        (val) => val.toString().split('.').last.toLowerCase() == toLowerCase(),
        orElse: orElse,
      );

  // Returns the number of words separable by spaces.
  // A word must contain at least one letter.
  int get wordCount => split(' ').where((word) => word.containsLetter).length;

  // Returns true if the uppercase version of this string is identical
  bool get isCapital => this == toUpperCase();

  // Returns true if this string can be parsed to a double
  bool get isNumeric => double.tryParse(this ?? '') != null;

  // RegExp for finding letters
  static final _letter = RegExp(r'[a-z]', caseSensitive: false);

  // Returns true if this string is purely letters
  bool get isAlpha => _letter.allMatches(this).length == length;

  // Returns true if this string contains a letter from A-Z (case insensitive).
  bool get containsLetter => _letter.hasMatch(this);
}
