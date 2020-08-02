import 'package:flutter/material.dart';

class HighlightTextWord extends StatelessWidget {
  final String text;
  final bool highlighted;
  final bool selected;
  final bool leftNeighbor;
  final bool rightNeighbor;
  final Color backgroundColor;
  final Color highlightColor;
  final TextStyle style;

  final void Function() onTap;
  final void Function() onSelectionStart;
  final void Function(Offset) onSelectionUpdate;
  final void Function() onSelectionEnd;
  final void Function() onSelectionCancel;

  HighlightTextWord(
    this.text,
    {
      this.highlighted = false,
      this.selected = false,
      this.leftNeighbor = false,
      this.rightNeighbor = false,
      this.backgroundColor,
      this.highlightColor,
      this.style,

      this.onTap,
      this.onSelectionStart,
      this.onSelectionUpdate,
      this.onSelectionEnd,
      this.onSelectionCancel,

      Key key
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _backgroundColor = backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    Color _highlightColor = highlightColor ?? Theme.of(context).textSelectionColor;
    TextStyle _style = style ?? DefaultTextStyle.of(context).style;

    Color color = _backgroundColor.withOpacity(0);
    if (selected)
      color = Color.lerp(_backgroundColor, _highlightColor, 0.5);
    else if (highlighted)
      color = _highlightColor;

    return GestureDetector(
      // Gestures
      onTap: onTap,

      onLongPressStart: (details) => onSelectionStart?.call(),
      onLongPressMoveUpdate: (details) => onSelectionUpdate?.call(details.globalPosition),
      onLongPressEnd: (details) => onSelectionEnd?.call(),

      onHorizontalDragStart: (details) => onSelectionStart?.call(),
      onHorizontalDragUpdate: (details) => onSelectionUpdate?.call(details.globalPosition),
      onHorizontalDragEnd: (details) => onSelectionEnd?.call(),
      onHorizontalDragCancel: () => onSelectionCancel?.call(),

      // Highlighted word
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
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.horizontal(
                              left: leftNeighbor ? Radius.zero : Radius.circular(6),
                              right: rightNeighbor ? Radius.zero : Radius.circular(6)
                          )
                      ),
                    ),
                  ),
                )
            ),

            // Text of word
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(text, style: _style),
            )
          ],
        ),
      ),
    );
  }
}
