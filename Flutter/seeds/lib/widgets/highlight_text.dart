import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HighlightText extends StatefulWidget {
  final String text;
  final List<String> words;
  final int disabledWords;

  final void Function(List<bool>) onChangeHighlight;

  HighlightText(String text, {this.onChangeHighlight, this.disabledWords = 0, Key key}) :
      this.text = text,
      words = text.split(' ').toList(),
      super(key: key);

  @override
  _HighlightTextState createState() => _HighlightTextState();
}

enum HighlightAppearance {
  off, changing, on
}

class _HighlightTextState extends State<HighlightText> {

  List<bool> _highlightedWords;
  List<GlobalKey> _wordKeys;

  int _highlightStart;
  int _highlightEnd;
  bool _highlightAction;

  // Returns true if the word is highlighted or will be highlighted
  HighlightAppearance appearsHighlighted(int word)
  {
    if (word < widget.disabledWords)
      return HighlightAppearance.off;

    if (_highlightStart != null) {
      if (word >= min(_highlightStart, _highlightEnd) &&
          word <= max(_highlightStart, _highlightEnd) &&
          _highlightedWords[word] != _highlightAction)
        return HighlightAppearance.changing;
    }

    if (_highlightedWords[word])
      return HighlightAppearance.on;
    else
      return HighlightAppearance.off;
  }

  // Determines which word is displayed at the given point on screen
  // Returns null if no word is present at that location
  int getWordAt(Offset globalPos)
  {
    for (int i = 0; i < _wordKeys.length; i++)
    {
      RenderBox wordBox = _wordKeys[i].currentContext.findRenderObject();
      Size size = wordBox.size;
      Offset localPos = wordBox.globalToLocal(globalPos);

      if (localPos.dx > 0 && localPos.dx < size.width &&
          localPos.dy > 0 && localPos.dy < size.height)
        return i;
    }

    return null;
  }

  // Updates highlight selection based on which word the tap is currently on
  void updateHighlight(int currentWord, {bool setStart = false, bool apply = false})
  {
    if (currentWord != null && currentWord < widget.disabledWords)
      currentWord = null;

    setState(() {
      if (setStart) {
        _highlightStart = currentWord;
        _highlightEnd = currentWord;

        if (currentWord != null)
          _highlightAction = !_highlightedWords[currentWord];
      } else if (currentWord != null && _highlightStart != null) {
        _highlightEnd = currentWord;
      }
    });

    if (apply && _highlightStart != null && _highlightEnd != null)
    {
      applyHighlight(min(_highlightStart, _highlightEnd), max(_highlightStart, _highlightEnd), _highlightAction);
      _highlightStart = _highlightEnd = null;
    }
  }

  // Applies highlight selection to highlight data
  void applyHighlight(int start, int end, bool highlighted)
  {
    setState(() {
      for (int i = start; i <= end; i++)
        if (i >= widget.disabledWords)
          _highlightedWords[i] = highlighted;

      widget.onChangeHighlight(_highlightedWords);
    });
  }

  // Uses the list of words to build a list of widgets
  List<Widget> buildParagraph(BuildContext context)
  {
    List<Widget> children = List<Widget>(widget.words.length);

    Color highlightColor = Theme.of(context).textSelectionColor;
    Color changingColor = Color.lerp(
      Theme.of(context).textSelectionColor,
      Theme.of(context).scaffoldBackgroundColor,
      0.5
    );
    Color offColor = Theme.of(context).scaffoldBackgroundColor; //Theme.of(context).textSelectionColor.withAlpha(0);

    for (int i = 0; i < widget.words.length; i++) {
      // Select color for decoration box
      Color boxColor = (appearsHighlighted(i) != HighlightAppearance.on) ?
      ((appearsHighlighted(i) == HighlightAppearance.off) ? offColor : changingColor) :
      highlightColor;

      children[i] = GestureDetector(
        // Detect taps to change highlight
        onTap: () {
          if (i >= widget.disabledWords)
            setState(() {
              _highlightedWords[i] = !_highlightedWords[i];
              widget.onChangeHighlight(_highlightedWords);
            });
        },

        // Animated for changing highlight
        child: AnimatedContainer(
          key: _wordKeys[i],

          duration: Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: boxColor,

            // Corners are rounded at ends of highlighted region
            borderRadius: BorderRadius.horizontal(
              left: (i == 0 || appearsHighlighted(i - 1) == HighlightAppearance.off) ? Radius.circular(5) : Radius.zero,
              right: (i == (widget.words.length - 1) ||  appearsHighlighted(i + 1) == HighlightAppearance.off) ? Radius.circular(5) : Radius.zero
            ),
          ),

          // Padding to separate words
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.5, vertical: 2),

            // Word text
            child: Text(
              '${widget.words[i]}',
              style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(
                fontFamily: 'Buenard',
                fontSize: 20
              ))
            ),
          ),
        ),
      );
    }

    return children;
  }

  @override
  void initState() {
    super.initState();
    _highlightedWords = List<bool>.filled(widget.words.length, false);
    _wordKeys = _highlightedWords.map((e) => GlobalKey()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detect highlighting gestures
      onLongPressStart: (LongPressStartDetails details) => updateHighlight(getWordAt(details.globalPosition), setStart: true),
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) => updateHighlight(getWordAt(details.globalPosition)),
      onLongPressEnd: (LongPressEndDetails details) => updateHighlight(getWordAt(details.globalPosition), apply: true),

      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: -0.5,
        runSpacing: 4,
        children: buildParagraph(context)
      ),
    );
  }
}
