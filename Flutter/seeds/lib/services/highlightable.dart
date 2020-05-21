import 'dart:math';
import 'package:flutter/material.dart';

class Highlightable extends StatefulWidget {
  final String text;
  Highlightable({Key key, this.text}) : super(key: key);

  @override
  _HighlightableState createState() => _HighlightableState();
}

class _HighlightableState extends State<Highlightable> {

  List<Widget> createParagraph(BuildContext context, String str)
  {
    List<String> words = str.split(' ');
    List<Widget> children = List<Widget>(words.length);

    for (int i = 0; i < words.length; i++) {
      Text textChild = Text(
        '${words[i]}',
        style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(
          fontFamily: 'Buenard',
          fontSize: 20
        ))
      );

      // Apply padding to all words except the last
      if (i < words.length - 1)
        children[i] = Padding(
          padding: EdgeInsets.only(right: 5),
          child: textChild,
        );
      else
        children[i] = textChild;
    }

    return children;
  }

  Offset highlightStart;
  Offset highlightEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detect highlighting gestures
      onLongPressStart: (LongPressStartDetails details) {
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
      },

      child: Stack(
        overflow: Overflow.visible,

        children: <Widget>[
          // Highlight visual
          Positioned(
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
          ),

          // Text
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            children: createParagraph(context, widget.text)
          )
        ]
      ),
    );
  }
}
