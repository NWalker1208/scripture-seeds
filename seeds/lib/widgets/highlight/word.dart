import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../../extensions/string.dart';

class Word {
  final TextRange range;
  bool highlighted;

  Word._(this.range, {this.highlighted = false});

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

@immutable
class WordSelection {
  final Word start;
  final Word end;

  const WordSelection(this.start, this.end);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WordSelection && other.start == start && other.end == end;
  }

  @override
  int get hashCode => hashValues(start.hashCode, end.hashCode);
}

extension IterableExtension on Iterable<Word> {
  Word atPosition(TextPosition position) {
    if (position == null) return null;
    var offset = position.offset;
    return firstWhere((word) => offset <= word.range.end, orElse: () => last);
  }
}

extension SelectionExtension on TextSelection {
  WordSelection toWordSelection(Iterable<Word> words) {
    final start = baseOffset <= extentOffset ? base : extent;
    final end = baseOffset <= extentOffset ? extent : base;
    return WordSelection(words.atPosition(start), words.atPosition(end));
  }
}
