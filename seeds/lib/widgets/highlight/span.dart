import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'word.dart';

class HighlightTextSpan extends StatefulWidget {
  final String text;
  final String leadingText;
  final TextStyle style;
  final Color backgroundColor;
  final Color highlightColor;

  final void Function(List<bool> highlight, String quote) onHighlightChange;

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

  bool _selectionAction;
  int _selectionStart;
  int _selectionEnd;

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
    if (_selectionStart != null &&
        _selectionEnd != null &&
        ((index >= _selectionStart && index <= _selectionEnd) ||
            (index <= _selectionStart && index >= _selectionEnd)) &&
        _words[index].highlighted != _selectionAction) {
      return true;
    } else {
      return false;
    }
  }

  void _notifyHighlightChange() => widget.onHighlightChange?.call(
      _words.map((word) => word.highlighted).toList(), getSharableQuote());

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
        _notifyHighlightChange();
      });
    }
  }

  void _startSelection(Offset position) {
    var index = _wordAtPosition(position);
    if (index != null) {
      setState(() {
        _selectionAction = !_words[index].highlighted;
        _selectionStart = index;
        _selectionEnd = index;
      });
    }
  }

  void _updateSelection(Offset position) {
    var index = _wordAtPosition(position);
    if (index != null) setState(() => _selectionEnd = index);
  }

  void _clearSelection() {
    setState(() {
      _selectionAction = null;
      _selectionStart = null;
      _selectionEnd = null;
    });
  }

  void _applySelection() {
    if (_selectionStart != null && _selectionEnd != null) {
      int start, end;
      if (_selectionEnd >= _selectionStart) {
        start = _selectionStart;
        end = _selectionEnd;
      } else {
        start = _selectionEnd;
        end = _selectionStart;
      }

      setState(() {
        for (var i = start; i <= end; i++) {
          _words[i].highlighted = _selectionAction;
        }

        _selectionAction = null;
        _selectionStart = null;
        _selectionEnd = null;

        _notifyHighlightChange();
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
      child: Wrap(
        runSpacing: 4.0,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(widget.leadingText, style: style),
          ),
          for (var i = 0; i < _words.length; i++)
            HighlightTextWord(
              _words[i].text,
              highlighted: isHighlighted(i),
              selected: isSelected(i),
              leftNeighbor: isHighlighted(i - 1) || isSelected(i - 1),
              rightNeighbor: isHighlighted(i + 1) || isSelected(i + 1),
              backgroundColor: backgroundColor,
              highlightColor: highlightColor,
              style: style,
              key: _words[i].key,
            ),
        ],
      ),
    );
  }
}
