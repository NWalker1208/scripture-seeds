import 'package:flutter/material.dart';

/// Selection widget responsible for detecting gestures.
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
  TextPosition startPosition;
  TextPosition lastPosition;

  /// Converts an offset to a text position and passes it to action.
  /// If the offset is not a valid text position, it does nothing.
  void select(Offset offset, Function(TextPosition) action) {
    var pos = widget.offsetToPosition(offset);
    if (pos != null) action?.call(pos);
  }

  /// Toggle the selection at the given position.
  void toggle(TextPosition pos) {
    widget.onSelectionDone?.call(TextSelection.fromPosition(pos));
  }

  /// Start a selection at the given position.
  void start(TextPosition pos) {
    setState(() => startPosition = pos);
    setState(() => lastPosition = pos);
    widget.onSelectionStart?.call(pos);
  }

  /// Update the end of the selection to the given position.
  void update(TextPosition pos) {
    setState(() => lastPosition = pos);
    widget.onSelectionUpdate?.call(TextSelection(
      baseOffset: startPosition.offset,
      extentOffset: pos.offset,
    ));
  }

  /// End the selection at the given position, or the last position updated.
  void end([TextPosition pos]) {
    if (pos != null) setState(() => lastPosition = pos);
    pos ??= lastPosition;
    widget.onSelectionDone?.call(TextSelection(
      baseOffset: startPosition.offset,
      extentOffset: pos.offset,
    ));
  }

  /// Cancel the selection.
  void cancel() => widget.onSelectionUpdate?.call(null);

  @override
  Widget build(BuildContext context) => GestureDetector(
        // Toggle
        onTapUp: (details) => select(details.localPosition, toggle),
        // Horizontal swipe
        onHorizontalDragStart: (details) =>
            select(details.localPosition, start),
        onHorizontalDragUpdate: (details) =>
            select(details.localPosition, update),
        onHorizontalDragEnd: (details) => end(),
        onHorizontalDragCancel: cancel,
        // Long press
        onLongPressStart: (details) => select(details.localPosition, start),
        onLongPressMoveUpdate: (details) =>
            select(details.localPosition, update),
        onLongPressEnd: (details) => select(details.localPosition, end),
        // Child
        child: widget.child ?? Container(),
      );
}
