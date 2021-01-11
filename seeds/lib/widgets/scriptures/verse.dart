import 'package:flutter/material.dart';

import '../selection/highlight.dart';
import '../selection/word.dart';

typedef VerseHighlightChangeHandler = Function(int verse, String quote);

class VerseView extends StatelessWidget {
  const VerseView(
    this.number,
    this.text, {
    this.style,
    this.onHighlightChange,
    Key key,
  }) : super(key: key);

  final int number;
  final String text;
  final TextStyle style;
  final VerseHighlightChangeHandler onHighlightChange;

  String _getQuote(Iterable<Word> words) {
    if (!words.any((word) => word.highlighted)) return '';

    final paragraph = '$number. $text';
    var quote = '';
    bool continuous;

    for (var word in words) {
      if (word.highlighted) {
        if (continuous ?? false) quote += ' ';
        quote += word.range.textInside(paragraph);
        continuous = true;
      } else {
        if (continuous ?? false) quote += '...';
        continuous = false;
      }
    }

    return quote;
  }

  @override
  Widget build(BuildContext context) {
    final _style = style ?? Theme.of(context).textTheme.bodyText1;

    return HighlightParagraph(
      text: '$number. $text',
      style: _style,
      highlightShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      onHighlightChange: (words) {
        onHighlightChange?.call(number, _getQuote(words));
      },
    );
  }
}
