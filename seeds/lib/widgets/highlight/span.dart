import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'word.dart';

class HighlightTextSpan extends StatefulWidget {
  final String text;
  final String leadingText;
  final TextStyle style;
  final Color backgroundColor;
  final Color highlightColor;

  final void Function(List<bool>) onHighlightChange;

  HighlightTextSpan(
    this.text, {
    this.leadingText = '',
    this.style,
    this.backgroundColor,
    this.highlightColor,
    this.onHighlightChange,
    Key key,
  }) : super(key: key);

  @override
  HighlightTextSpanState createState() => HighlightTextSpanState();
}

class _WordState {
  final String text;
  final GlobalKey key;
  bool highlighted;

  _WordState(this.text, {GlobalKey key, this.highlighted = false})
      : key = key ?? GlobalKey();

  static List<_WordState> buildWordList(String text) =>
      text.split(' ').map((t) => _WordState(t)).toList();
}

class HighlightTextSpanState extends State<HighlightTextSpan> {
  List<_WordState> _words;

  bool selectionAction;
  int selectionStart;
  int selectionEnd;

  List<String> get words => _words.map((word) => word.text).toList();

  String getSharableQuote() {
    var quote = '';

    bool continued;
    for (var word in _words) {
      if (word.highlighted) {
        if (!(continued ?? true)) quote += ' ';

        quote += word.text;
        continued = false;
      } else {
        if (!(continued ?? false)) quote += '...';

        continued = true;
      }
    }

    return quote;
  }

  bool isHighlighted(int index) => (index < 0 || index > _words.length - 1)
      ? false
      : _words[index].highlighted;

  bool isSelected(int index) {
    // Check if index is out of range
    if (index < 0 || index > _words.length - 1) return false;

    // Check if index is within selection
    if (selectionStart != null &&
        selectionEnd != null &&
        ((index >= selectionStart && index <= selectionEnd) ||
            (index <= selectionStart && index >= selectionEnd)) &&
        _words[index].highlighted != selectionAction) {
      return true;
    } else {
      return false;
    }
  }

  void _notifyHighlightUpdate() =>
      widget.onHighlightChange(_words.map((word) => word.highlighted).toList());

  int _wordAtPosition(Offset position) {
    // Check if position falls on any of the words in the span
    for (var i = 0; i < _words.length; i++) {
      var renderBox =
          _words[i].key.currentContext.findRenderObject() as RenderBox;
      var localPosition = renderBox.globalToLocal(position);
      var result = BoxHitTestResult();

      if (renderBox.hitTest(result, position: localPosition)) return i;
    }

    // Check if position is before first word
    var firstRenderBox =
        _words.first.key.currentContext.findRenderObject() as RenderBox;
    var firstLocalPosition = firstRenderBox.globalToLocal(position);

    if (firstLocalPosition.dy < 0 ||
        (firstLocalPosition.dy < firstRenderBox.size.height &&
            firstLocalPosition.dx < 0)) {
      return 0;
    }

    // Check if position is after last word
    var lastRenderBox =
        _words.last.key.currentContext.findRenderObject() as RenderBox;
    var lastLocalPosition = lastRenderBox.globalToLocal(position);

    if (lastLocalPosition.dy > lastRenderBox.size.height ||
        (lastLocalPosition.dy > 0 &&
            lastLocalPosition.dx > lastRenderBox.size.width)) {
      return _words.length - 1;
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
        setState(() {
          _words[index].highlighted = !_words[index].highlighted;
        });
        _notifyHighlightUpdate();
      });
    }
  }

  void _startSelection(Offset position) {
    var index = _wordAtPosition(position);
    if (index != null) {
      setState(() {
        selectionAction = !_words[index].highlighted;
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
      int start, end;
      if (selectionEnd >= selectionStart) {
        start = selectionStart;
        end = selectionEnd;
      } else {
        start = selectionEnd;
        end = selectionStart;
      }

      setState(() {
        for (var i = start; i <= end; i++) {
          _words[i].highlighted = selectionAction;
        }

        selectionAction = null;
        selectionStart = null;
        selectionEnd = null;

        _notifyHighlightUpdate();
      });
    }
  }

  /// Widget functions
  @override
  void initState() {
    _words = _WordState.buildWordList(widget.text);
    super.initState();
  }

  @override
  void didUpdateWidget(HighlightTextSpan oldWidget) {
    if (widget.text != oldWidget.text) {
      setState(() {
        _words = _WordState.buildWordList(widget.text);
      });
    }

    super.didUpdateWidget(oldWidget);
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
            _words.length,
            (index) => WidgetSpan(
              child: HighlightTextWord(
                _words[index].text,
                highlighted: isHighlighted(index),
                selected: isSelected(index),
                leftNeighbor: isHighlighted(index - 1) || isSelected(index - 1),
                rightNeighbor:
                    isHighlighted(index + 1) || isSelected(index + 1),
                backgroundColor: backgroundColor,
                highlightColor: highlightColor,
                style: style,
                key: _words[index].key,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
