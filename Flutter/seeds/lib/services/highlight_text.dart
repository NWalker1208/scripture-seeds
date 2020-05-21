import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HighlightText extends StatefulWidget {
  final String text;
  final List<String> words;

  HighlightText(String text, {Key key}) :
      this.text = text,
      words = text.split(' ').toList(),
      super(key: key);

  @override
  _HighlightTextState createState() => _HighlightTextState();
}

class _HighlightTextState extends State<HighlightText> {
  List<GlobalKey> wordKeys;
  List<bool> highlight;

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

  List<Widget> buildParagraph(BuildContext context)
  {
    List<Widget> children = List<Widget>(widget.words.length);

    for (int i = 0; i < widget.words.length; i++) {
      // Padding to separate words
      
      children[i] = GestureDetector(
        onTap: () {
          setState(() {
            highlight[i] = !highlight[i];
          });
        },
        
        child: AnimatedContainer(
          key: wordKeys[i],
          duration: Duration(milliseconds: 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: (i == 0 || !highlight[i - 1]) ? Radius.circular(5) : Radius.zero,
              right: (i == (widget.words.length - 1) || !highlight[i + 1]) ? Radius.circular(5) : Radius.zero
            ),
            
            color: Theme.of(context).textSelectionColor.withAlpha(highlight[i] ? 255 : 0),
          ),
          
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.5, vertical: 2),
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
    highlight = List<bool>.filled(widget.words.length, false);
    wordKeys = highlight.map((e) => GlobalKey()).toList();
  }

  int highlightStart;
  int highlightEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detect highlighting gestures
      onLongPressStart: (LongPressStartDetails details) {
        highlightStart = getWordAt(details.globalPosition);
        highlightEnd = highlightStart;

        setState(() {
          highlight[highlightStart] = true;
        });
      },
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
        int currentWord = getWordAt(details.globalPosition);
        if (currentWord != null && currentWord != highlightEnd) {
          highlightEnd = currentWord;

          setState(() {
            if (highlightStart <= highlightEnd)
              for (int i = highlightStart; i <= highlightEnd; i++)
                highlight[i] = true;
            else
              for (int i = highlightStart; i >= highlightEnd; i--)
                highlight[i] = true;
          });
        }
      },
      onLongPressEnd: (LongPressEndDetails details) {
        int currentWord = getWordAt(details.globalPosition);
        if (currentWord != null)
          highlightEnd = currentWord;

        print('$highlightStart -> $highlightEnd');

        setState(() {
          if (highlightStart <= highlightEnd)
            for (int i = highlightStart; i <= highlightEnd; i++)
              highlight[i] = true;
          else
            for (int i = highlightStart; i >= highlightEnd; i--)
              highlight[i] = true;
        });
      },

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
