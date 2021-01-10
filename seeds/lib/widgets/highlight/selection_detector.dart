import 'package:flutter/material.dart';

// Responsible for:
//  - Gestures

class SelectionDetector extends StatefulWidget {
  const SelectionDetector({
    this.child,
    @required this.offsetToPosition,
    this.onSelectionStart,
    this.onSelectionUpdate,
    this.onSelectionDone,
    Key key,
  }) : super(key: key);

  final Widget child;
  final TextPosition Function(Offset offset) offsetToPosition;
  final Function(TextPosition position) onSelectionStart;
  final Function(TextSelection selection) onSelectionUpdate;
  final Function(TextSelection selection) onSelectionDone;

  @override
  _SelectionDetectorState createState() => _SelectionDetectorState();
}

class _SelectionDetectorState extends State<SelectionDetector> {
  TextPosition start;

  void select(Offset offset, Function(TextPosition) action) {
    var pos = widget.offsetToPosition(offset);
    if (pos != null) setState(() => action?.call(pos));
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapUp: (details) => select(details.localPosition, (pos) {
          //widget.onSelectionStart?.call(pos);
          widget.onSelectionDone?.call(TextSelection.fromPosition(pos));
        }),
        onLongPressStart: (details) => select(details.localPosition, (pos) {
          start = pos;
          widget.onSelectionStart?.call(pos);
        }),
        onLongPressMoveUpdate: (details) => select(
            details.localPosition,
            (pos) => widget.onSelectionUpdate?.call(TextSelection(
                  baseOffset: start.offset,
                  extentOffset: pos.offset,
                ))),
        onLongPressEnd: (details) => select(
            details.localPosition,
            (pos) => widget.onSelectionDone?.call(TextSelection(
                  baseOffset: start.offset,
                  extentOffset: pos.offset,
                ))),
        child: widget.child ?? Container(),
      );
}
