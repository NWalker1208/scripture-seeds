import 'package:flutter/material.dart';

import '../../services/utility.dart';
import 'word.dart';

class WordState {
  String text;
  bool highlighted;

  WordState(this.text, {this.highlighted = false});
}

List<WordState> buildWordList(String text) =>
    text.split(' ').map((t) => WordState(t)).toList();

String buildSharableQuote(List<WordState> words) {
  var quote = '';

  var continued = true;
  for (var word in words) {
    if (word.highlighted) {
      if (!continued) quote += ' ';

      quote += word.text;
      continued = false;
    } else {
      if (!continued) quote += '...';

      continued = true;
    }
  }

  return quote;
}

class HighlightTextSpan extends StatefulWidget {
  final String leadingText;
  final List<WordState> words;
  final TextStyle style;
  final Color backgroundColor;
  final Color highlightColor;

  final void Function(Map<int, bool>) onChangeHighlight;

  HighlightTextSpan(
    this.words, {
    this.leadingText = '',
    this.style,
    this.backgroundColor,
    this.highlightColor,
    this.onChangeHighlight,
    Key key,
  }) : super(key: key);

  @override
  HighlightTextSpanState createState() => HighlightTextSpanState();
}

enum _HighlightAppearance { off, selected, on }

class HighlightTextSpanState extends State<HighlightTextSpan> {
  List<GlobalKey> _wordKeys;

  bool selectionAction;
  int selectionStart;
  int selectionEnd;

  HighlightTextSpanState();

  _HighlightAppearance _wordState(int index) {
    if (index < 0 || index > widget.words.length - 1) {
      return _HighlightAppearance.off;
    }

    if (selectionStart != null &&
        selectionEnd != null &&
        ((index >= selectionStart && index <= selectionEnd) ||
            (index <= selectionStart && index >= selectionEnd)) &&
        widget.words[index].highlighted != selectionAction) {
      return _HighlightAppearance.selected;
    } else if (widget.words[index].highlighted) {
      return _HighlightAppearance.on;
    } else {
      return _HighlightAppearance.off;
    }
  }

  /// Gesture handlers
  void _updateSelection(Offset position) {
    var word = hitTestList(position, _wordKeys);
    if (word != null) setState(() => selectionEnd = word);
  }

  /// Selection management functions
  void _startSelection(int index) {
    setState(() {
      selectionAction = !widget.words[index].highlighted;
      selectionStart = index;
      selectionEnd = index;
    });
  }

  void _clearSelection() {
    setState(() {
      selectionAction = null;
      selectionStart = null;
      selectionEnd = null;
    });
  }

  void _applySelection() {
    if (selectionStart != null && selectionEnd != null) {
      setState(() {
        int start, end;
        if (selectionEnd >= selectionStart) {
          start = selectionStart;
          end = selectionEnd;
        } else {
          start = selectionEnd;
          end = selectionStart;
        }

        var changes = <int, bool>{};
        for (var i = start; i <= end; i++) {
          if (selectionAction != widget.words[i].highlighted) {
            changes[i] = selectionAction;
          }
        }

        selectionAction = null;
        selectionStart = null;
        selectionEnd = null;

        widget.onChangeHighlight?.call(changes);
      });
    }
  }

  void _quickSelect(int index) {
    setState(() {
      _clearSelection();
      var change = <int, bool>{index: !widget.words[index].highlighted};
      widget.onChangeHighlight?.call(change);
    });
  }

  /// Widget functions
  @override
  void initState() {
    super.initState();
    _wordKeys = List<GlobalKey>.generate(widget.words.length,
        (index) => GlobalKey(debugLabel: widget.words[index].text));
  }

  @override
  void didUpdateWidget(HighlightTextSpan oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.words.length != widget.words.length) {
      setState(() {
        _wordKeys = List<GlobalKey>.generate(
          widget.words.length,
          (index) => GlobalKey(debugLabel: widget.words[index].text),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColor =
        widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    var highlightColor = widget.highlightColor ??
        Theme.of(context).textSelectionTheme.selectionColor;
    var style = widget.style ?? DefaultTextStyle.of(context).style;

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        text: widget.leadingText,
        style: style,
        // Generate a list of textSpans for the words
        children: List<InlineSpan>.generate(
          widget.words.length,
          (index) => WidgetSpan(
            child: HighlightTextWord(
              widget.words[index].text,
              highlighted: _wordState(index) == _HighlightAppearance.on,
              selected: _wordState(index) == _HighlightAppearance.selected,
              leftNeighbor: _wordState(index - 1) != _HighlightAppearance.off,
              rightNeighbor: _wordState(index + 1) != _HighlightAppearance.off,
              backgroundColor: backgroundColor,
              highlightColor: highlightColor,
              style: style,
              onTap: () => _quickSelect(index),
              onSelectionStart: () => _startSelection(index),
              onSelectionUpdate: _updateSelection,
              onSelectionEnd: _applySelection,
              key: _wordKeys[index],
            ),
          ),
        ),
      ),
    );
  }
}
