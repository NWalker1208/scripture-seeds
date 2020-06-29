import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seeds/services/utility.dart';

class HighlightRichText extends StatefulWidget {
  final String text, leadingText;
  final TextStyle style;
  final Color backgroundColor;
  final Color highlightColor;

  final void Function(List<bool>) onChangeHighlight;

  HighlightRichText(this.text, {this.leadingText = '', this.style, this.backgroundColor, this.highlightColor, this.onChangeHighlight, Key key}) :
      super(key: key);

  @override
  _HighlightRichTextState createState() => _HighlightRichTextState();
}

enum _HighlightAppearance {
  off, selected, on
}

class _HighlightRichTextState extends State<HighlightRichText> {
  List<String> words;
  List<bool> highlightedWords;
  List<GlobalKey> _wordKeys;

  bool selectionAction;
  int selectionStart;
  int selectionEnd;

  _HighlightRichTextState();

  _HighlightAppearance _wordState(int index) {
    if (index < 0 || index > words.length - 1)
      return _HighlightAppearance.off;

    if (selectionStart != null && selectionEnd != null &&
        index >= selectionStart && index <= selectionEnd &&
        highlightedWords[index] != selectionAction)
      return _HighlightAppearance.selected;
    else if (highlightedWords[index])
      return _HighlightAppearance.on;
    else
      return _HighlightAppearance.off;
  }

  /// Gesture handlers
  void _handleDragUpdate(DragUpdateDetails details) {
    int word = hitTestList(details.globalPosition, _wordKeys);
    print('Word[$word] is below cursor');

    if (word != null)
      _updateSelection(word);
  }

  /// Selection management functions
  void _startSelection(int index) {
    setState(() {
      selectionAction = !highlightedWords[index];
      selectionStart = index;
      selectionEnd = index;
    });
  }

  void _updateSelection(int index) => setState(() => selectionEnd = index);

  void _clearSelection() {
    setState(() {
      selectionAction = null;
      selectionStart = null;
      selectionEnd = null;
    });
  }

  void _applySelection() {
    if (selectionStart != null && selectionEnd != null)
      setState(() {
        int start, end;
        if (selectionEnd >= selectionStart) {
          start = selectionStart;
          end = selectionEnd;
        } else {
          start = selectionEnd;
          end = selectionStart;
        }

        for (int i = start; i <= end; i++)
          highlightedWords[i] = selectionAction;

        selectionAction = null;
        selectionStart = null;
        selectionEnd = null;

        widget.onChangeHighlight(highlightedWords);
      });
  }

  /// Widget functions
  @override
  void initState() {
    super.initState();
    words = widget.text.split(' ');
    highlightedWords = List<bool>.filled(words.length, false);
    _wordKeys = List<GlobalKey>.generate(words.length, (index) => GlobalKey(debugLabel: words[index]));
  }

  @override
  void didUpdateWidget(HighlightRichText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text)
      setState(() {
        words = widget.text.split(' ');
        highlightedWords = List<bool>.filled(words.length, false);
        _wordKeys = List<GlobalKey>.generate(words.length, (index) => GlobalKey(debugLabel: words[index]));
      });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    Color highlightColor = widget.highlightColor ?? Theme.of(context).textSelectionColor;
    Color selectionColor = Color.lerp(backgroundColor, highlightColor, 0.5);
    TextStyle style = widget.style ?? DefaultTextStyle.of(context).style;

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        text: widget.leadingText,
        style: style,
        // Generate a list of textSpans for the words
        children: List<InlineSpan>.generate(words.length, (index) {
          Color color;
          if (_wordState(index) == _HighlightAppearance.off)
            color = backgroundColor.withOpacity(0);
          else if (_wordState(index) == _HighlightAppearance.selected)
            color = selectionColor;
          else if (_wordState(index) == _HighlightAppearance.on)
            color = highlightColor;

          return WidgetSpan(
            child: GestureDetector(
              key: _wordKeys[index],

              onTapDown: (details) => _startSelection(index),
              onTapUp: (details) => _applySelection(),
              onHorizontalDragStart: (details) => _startSelection(index),
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: (details) => _applySelection(),
              onHorizontalDragCancel: () => _clearSelection(),

              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Stack(
                  children: <Widget>[
                    // Highlight box
                    Positioned.fill(
                      child: FractionalTranslation(
                        translation: const Offset(0, 0.08),
                        child: Transform.scale(
                          scale: 1.01,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.horizontal(
                                left: (_wordState(index - 1) != _HighlightAppearance.off) ?
                                  Radius.zero : Radius.circular(6),
                                right: (_wordState(index + 1) != _HighlightAppearance.off) ?
                                  Radius.zero : Radius.circular(6)
                              )
                            ),
                          ),
                        ),
                      )
                    ),

                    // Text of word
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text('${words[index]}', style: style),
                    )
                  ],
                ),
              ),
            )
          );
        })
      )
    );
  }
}
