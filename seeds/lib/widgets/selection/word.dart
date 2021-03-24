import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../../extensions/string.dart';

/// Stores information about the location and state of a word.
class Word {
  Word._(this.range, {this.highlighted = false});

  final TextRange range;
  bool highlighted;

  static Iterable<Word> fromString(String text) {
    var words = <Word>[];
    int start;

    for (var i = 0; i <= text.length; i++) {
      var char = i < text.length ? text[i] : '';

      if (char.containsLetter) {
        start ??= i;
      } else {
        if (start != null) {
          words.add(Word._(TextRange(start: start, end: i)));
          start = null;
        }
      }
    }

    return words;
  }

  @override
  String toString() => '$range [$highlighted]';
}

/// Stores information about a range of selected words.
@immutable
class WordSelection {
  const WordSelection(this.start, this.end);

  final Word start;
  final Word end;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordSelection && other.start == start && other.end == end;

  @override
  int get hashCode => hashValues(start.hashCode, end.hashCode);
}

extension IterableExtension on Iterable<Word> {
  /// Find the word closest to the given text position.
  Word atPosition(TextPosition position) {
    if (position == null) return null;
    var offset = position.offset;
    return firstWhere((word) => offset <= word.range.end, orElse: () => last);
  }
}

extension SelectionExtension on TextSelection {
  /// Convert this selection into a WordSelection.
  WordSelection toWordSelection(Iterable<Word> words) {
    final start = baseOffset <= extentOffset ? base : extent;
    final end = baseOffset <= extentOffset ? extent : base;
    return WordSelection(words.atPosition(start), words.atPosition(end));
  }
}
