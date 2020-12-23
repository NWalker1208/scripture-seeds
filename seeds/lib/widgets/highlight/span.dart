import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  int _wordAtPosition(Offset position) {
    // Check if position falls on any of the words in the span
    for (var i = 0; i < _wordKeys.length; i++) {
      var renderBox =
          _wordKeys[i].currentContext.findRenderObject() as RenderBox;
      var localPosition = renderBox.globalToLocal(position);
      var result = BoxHitTestResult();

      if (renderBox.hitTest(result, position: localPosition)) return i;
    }

    // Check if position is before first word
    var firstRenderBox =
        _wordKeys.first.currentContext.findRenderObject() as RenderBox;
    var firstLocalPosition = firstRenderBox.globalToLocal(position);

    if (firstLocalPosition.dy < 0 ||
        (firstLocalPosition.dy < firstRenderBox.size.height &&
            firstLocalPosition.dx < 0)) {
      return 0;
    }

    // Check if position is after last word
    var lastRenderBox =
        _wordKeys.last.currentContext.findRenderObject() as RenderBox;
    var lastLocalPosition = lastRenderBox.globalToLocal(position);

    if (lastLocalPosition.dy > lastRenderBox.size.height ||
        (lastLocalPosition.dy > 0 &&
            lastLocalPosition.dx > lastRenderBox.size.width)) {
      return _wordKeys.length - 1;
    }

    // No word under position
    return null;
  }

  /// Gesture handlers
  // For each function, position indicates where a gesture occurred
  // to trigger this action.
  void _toggleHighlight(Offset position) {
    var index = _wordAtPosition(position);
    if (index != null) {
      setState(() {
        _clearSelection();
        var change = <int, bool>{index: !widget.words[index].highlighted};
        widget.onChangeHighlight?.call(change);
      });
    }
  }

  void _startSelection(Offset position) {
    var index = _wordAtPosition(position);
    if (index != null) {
      setState(() {
        selectionAction = !widget.words[index].highlighted;
        selectionStart = index;
        selectionEnd = index;
      });
    }
  }

  void _updateSelection(Offset position) {
    var index = _wordAtPosition(position);
    if (index != null) setState(() => selectionEnd = index);
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

  /// Widget functions
  @override
  void initState() {
    super.initState();
    _wordKeys = List<GlobalKey>.generate(
      widget.words.length,
      (index) => GlobalKey(debugLabel: widget.words[index].text),
    );
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

    return GestureDetector(
      // Tap to highlight
      onTapUp: (details) => _toggleHighlight(details.globalPosition),
      // Long press to highlight
      onLongPressStart: (details) => _startSelection(details.globalPosition),
      onLongPressMoveUpdate: (details) =>
          _updateSelection(details.globalPosition),
      onLongPressEnd: (_) => _applySelection(),
      // Swipe to highlight
      onHorizontalDragStart: (details) =>
          _startSelection(details.globalPosition),
      onHorizontalDragUpdate: (details) =>
          _updateSelection(details.globalPosition),
      onHorizontalDragEnd: (_) => _applySelection(),
      onHorizontalDragCancel: _clearSelection,

      // Text
      child: RichText(
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
                rightNeighbor:
                    _wordState(index + 1) != _HighlightAppearance.off,
                backgroundColor: backgroundColor,
                highlightColor: highlightColor,
                style: style,
                key: _wordKeys[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
