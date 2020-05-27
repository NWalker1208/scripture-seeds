import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HighlightText extends StatefulWidget {
  final String text;
  final List<String> words;
  final int disabledWords;

  HighlightText(String text, {this.disabledWords = 0, Key key}) :
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

  List<GlobalKey> wordKeys;
  List<bool> highlightedWords;

  int highlightStart;
  int highlightEnd;
  bool highlightAction;

  // Returns true if the word is highlighted or will be highlighted
  HighlightAppearance appearsHighlighted(int word)
  {
    if (word < widget.disabledWords)
      return HighlightAppearance.off;

    if (highlightStart != null) {
      if (word >= min(highlightStart, highlightEnd) &&
          word <= max(highlightStart, highlightEnd) &&
          highlightedWords[word] != highlightAction)
        return HighlightAppearance.changing;
    }

    if (highlightedWords[word])
      return HighlightAppearance.on;
    else
      return HighlightAppearance.off;
  }

  // Determines which word is displayed at the given point on screen
  // Returns null if no word is present at that location
  int getWordAt(Offset globalPos)
  {
    for (int i = 0; i < wordKeys.length; i++)
    {
      RenderBox wordBox = wordKeys[i].currentContext.findRenderObject();
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
        highlightStart = currentWord;
        highlightEnd = currentWord;

        if (currentWord != null)
          highlightAction = !highlightedWords[currentWord];
      } else if (currentWord != null && highlightStart != null) {
        highlightEnd = currentWord;
      }
    });

    if (apply && highlightStart != null && highlightEnd != null)
    {
      applyHighlight(min(highlightStart, highlightEnd), max(highlightStart, highlightEnd), highlightAction);
      highlightStart = highlightEnd = null;
    }
  }

  // Applies highlight selection to highlight data
  void applyHighlight(int start, int end, bool highlighted)
  {
    setState(() {
      for (int i = start; i <= end; i++)
        if (i >= widget.disabledWords)
          highlightedWords[i] = highlighted;
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
              highlightedWords[i] = !highlightedWords[i];
            });
        },

        // Animated for changing highlight
        child: AnimatedContainer(
          key: wordKeys[i],

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
    highlightedWords = List<bool>.filled(widget.words.length, false);
    wordKeys = highlightedWords.map((e) => GlobalKey()).toList();
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
        spacing: -1,
        runSpacing: 4,
        children: buildParagraph(context)
      ),
    );
  }
}
