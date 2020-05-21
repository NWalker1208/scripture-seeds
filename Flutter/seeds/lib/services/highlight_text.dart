import 'dart:math';
import 'package:flutter/material.dart';

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
  List<bool> highlight;

  List<Widget> buildParagraph(BuildContext context)
  {
    List<Widget> children = List<Widget>(widget.words.length);

    for (int i = 0; i < widget.words.length; i++) {
      // Padding to separate words
      children[i] = AnimatedContainer(
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

          child: GestureDetector(
            onTap: () {
              setState(() {
                highlight[i] = !highlight[i];
              });
            },

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

  Offset highlightStart;
  Offset highlightEnd;

  @override
  void initState() {
    super.initState();
    highlight = List<bool>.filled(widget.words.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detect highlighting gestures
      /*onLongPressStart: (LongPressStartDetails details) {
        setState(() {
          highlightStart = details.localPosition;
          highlightEnd = details.localPosition;
        });
      },
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
        setState(() {
          highlightEnd = details.localPosition;
        });
      },
      onLongPressEnd: (LongPressEndDetails details) {
        setState(() {
          highlightEnd = details.localPosition;
        });
      },*/

      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,

        children: <Widget>[
          // Highlight visual
          /*Positioned(
            left: highlightStart == null ? 0 : min(highlightStart.dx, highlightEnd.dx),
            top: highlightStart == null ? 0 : min(highlightStart.dy, highlightEnd.dy),
            width: highlightEnd == null ? 0 : (highlightEnd - highlightStart).dx.abs(),
            height: highlightEnd == null ? 0 : (highlightEnd - highlightStart).dy.abs(),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).textSelectionColor,
                borderRadius: BorderRadius.circular(5)
              ),
            )
          ),*/

          // Text
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            spacing: -1,
            runSpacing: 4,
            children: buildParagraph(context)
          )
        ]
      ),
    );
  }
}
