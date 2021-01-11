import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import 'detector.dart';
import 'paragraph.dart';
import 'render.dart';
import 'word.dart';

// Responsible for:
//  - Event handling
//  - State

typedef HighlightChangeHandler = Function(Iterable<Word> words);

class HighlightParagraph extends StatefulWidget {
  const HighlightParagraph({
    @required this.text,
    this.style,
    this.highlightColor,
    this.highlightShape,
    this.onHighlightChange,
    Key key,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final Color highlightColor;
  final ShapeBorder highlightShape;
  final HighlightChangeHandler onHighlightChange;

  @override
  HighlightParagraphState createState() => HighlightParagraphState();
}

class HighlightParagraphState extends State<HighlightParagraph>
    with AutomaticKeepAliveClientMixin {
  final _paragraphKey = GlobalKey();
  BuiltList<Word> _words;
  WordSelection _activeSelection;
  bool _selectionAction;

  RenderSelectionParagraph _getParagraph() =>
      _paragraphKey.currentContext.findRenderObject()
          as RenderSelectionParagraph;

  List<TextSelection> _getHighlights() {
    var highlights = <TextSelection>[];
    int start, end;

    for (var i = 0; i <= _words.length; i++) {
      final word = i < _words.length ? _words[i] : null;

      if (word?.highlighted ?? false) {
        start ??= word.range.start;
        end = word.range.end;
      } else if (start != null) {
        highlights.add(TextSelection(baseOffset: start, extentOffset: end));
        start = null;
      }
    }

    return highlights;
  }

  // Selection controls
  void _updateSelection(TextSelection selection) {
    final wordSelection = selection?.toWordSelection(_words);
    var action = _words.atPosition(selection?.base)?.highlighted;
    if (action != null) action = !action;

    if (_activeSelection != wordSelection || _selectionAction != action) {
      setState(() {
        _selectionAction = action;
        _activeSelection = wordSelection;
      });
    }
  }

  void _applySelection() {
    if (_activeSelection == null) return;

    final changingWords = _words.sublist(
      _words.indexOf(_activeSelection.start),
      _words.indexOf(_activeSelection.end) + 1,
    );

    setState(() {
      for (var word in changingWords) {
        word.highlighted = _selectionAction;
      }
      _updateSelection(null);
      _notifyHighlightChange();
    });
  }

  void _notifyHighlightChange() {
    updateKeepAlive();
    widget.onHighlightChange?.call(_words);
  }

  // Selection handlers
  TextPosition _offsetToPosition(Offset localOffset) =>
      _getParagraph()?.getPositionForOffset(localOffset);

  void _handleSelectionStart(TextPosition position) =>
      _updateSelection(TextSelection.fromPosition(position));

  void _handleSelectionDone(TextSelection selection) {
    _updateSelection(selection);
    _applySelection();
  }

  // Widget methods
  @override
  bool get wantKeepAlive => _words.any((word) => word.highlighted);

  @override
  void initState() {
    _words = Word.fromString(widget.text).toBuiltList();
    super.initState();
  }

  @override
  void didUpdateWidget(HighlightParagraph oldWidget) {
    _words = Word.fromString(widget.text).toBuiltList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final style = widget.style ?? DefaultTextStyle.of(context).style;
    final color = widget.highlightColor ??
        Theme.of(context).textSelectionTheme.selectionColor;
    final shape = widget.highlightShape ?? const Border();

    final background = Theme.of(context).backgroundColor;
    final selectionColor = _selectionAction ?? true
        ? color.withOpacity(0.5)
        : background.withOpacity(0.5);

    return SelectionDetector(
      offsetToPosition: _offsetToPosition,
      onSelectionStart: _handleSelectionStart,
      onSelectionUpdate: _updateSelection,
      onSelectionDone: _handleSelectionDone,
      child: SelectionParagraph(
        key: _paragraphKey,
        text: TextSpan(text: '${widget.text}', style: style),
        selections: [
          for (var highlight in _getHighlights())
            SelectionDecoration(
                selection: highlight, color: color, shape: shape),
          if (_activeSelection != null)
            SelectionDecoration(
              selection: TextSelection(
                baseOffset: _activeSelection.start.range.start,
                extentOffset: _activeSelection.end.range.end,
              ),
              color: selectionColor,
              shape: shape,
            ),
        ],
      ),
    );
  }
}
