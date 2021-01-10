import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import 'delegate.dart';
import 'render.dart';
import 'selection_detector.dart';
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

  RenderHighlightParagraph _getParagraph() =>
      _paragraphKey.currentContext.findRenderObject()
          as RenderHighlightParagraph;

  List<TextSelection> _getHighlights() {
    var highlights = <TextSelection>[];
    int start, end;

    final selStartIndex = _words.indexOf(_activeSelection?.start);
    final selEndIndex = _words.indexOf(_activeSelection?.end);

    for (var i = 0; i <= _words.length; i++) {
      final word = i < _words.length ? _words[i] : null;

      if ((word?.highlighted ?? false) ||
          (_activeSelection != null &&
              i >= selStartIndex &&
              i <= selEndIndex)) {
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
    if (_activeSelection != wordSelection) {
      setState(() => _activeSelection = wordSelection);
    }
  }

  void _applySelection(TextSelection selection, bool action) {
    final wordSelection = selection.toWordSelection(_words);

    final changingWords = _words.sublist(
      _words.indexOf(wordSelection.start),
      _words.indexOf(wordSelection.end) + 1,
    );

    setState(() {
      for (var word in changingWords) {
        word.highlighted = action;
      }
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
    _updateSelection(null);
    final action = !_words.atPosition(selection.base).highlighted;
    _applySelection(selection, action);
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
    return SelectionDetector(
      offsetToPosition: _offsetToPosition,
      onSelectionStart: _handleSelectionStart,
      onSelectionUpdate: _updateSelection,
      onSelectionDone: _handleSelectionDone,
      child: HighlightParagraphDelegate(
        text: '${widget.text}',
        highlights: _getHighlights(),
        highlightColor: widget.highlightColor,
        highlightShape: widget.highlightShape,
        textStyle: widget.style,
        key: _paragraphKey,
      ),
    );
  }
}
