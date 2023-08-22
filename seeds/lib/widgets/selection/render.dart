import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Stores information about how to render a selection.
@immutable
class SelectionDecoration {
  final TextSelection selection;
  final Color color;
  final ShapeBorder shape;

  const SelectionDecoration({
    @required this.selection,
    this.color = Colors.blue,
    this.shape = const Border(),
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectionDecoration &&
        other.selection == selection &&
        other.color == color &&
        other.shape == shape;
  }

  @override
  int get hashCode => hashValues(selection, color, shape);
}

/// Render object for selection widget.
/// TODO: Add animations
class RenderSelectionParagraph extends RenderParagraph {
  RenderSelectionParagraph({
    InlineSpan text,
    Iterable<SelectionDecoration> selectionDecorations,
    TextAlign textAlign = TextAlign.start,
    TextHeightBehavior textHeightBehavior,
    double textScaleFactor = 1.0,
    @required TextDirection textDirection,
    Locale locale,
  })  : _selectionDecorations = selectionDecorations.toBuiltList(),
        super(
          text,
          textAlign: textAlign,
          textHeightBehavior: textHeightBehavior,
          textScaleFactor: textScaleFactor,
          textDirection: textDirection,
          locale: locale,
        );

  BuiltList<SelectionDecoration> _selectionDecorations;
  Iterable<SelectionDecoration> get selectionDecorations => _selectionDecorations;
  set selectionDecorations(Iterable<SelectionDecoration> values) {
    var builtValues = values.toBuiltList();
    if (_selectionDecorations != builtValues) {
      _selectionDecorations = builtValues;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    for (var selection in selectionDecorations) {
      _paintSelection(canvas, selection);
    }

    canvas.restore();
    super.paint(context, offset);
  }

  void _paintSelection(Canvas canvas, SelectionDecoration selection) {
    final paint = Paint()
      ..color = selection.color
      ..style = PaintingStyle.fill;

    for (var box in getBoxesForSelection(selection.selection)) {
      final rect = Rect.fromLTRB(box.left, box.top, box.right, box.bottom);
      canvas.drawPath(
        selection.shape.getOuterPath(rect, textDirection: textDirection),
        paint,
      );
    }
  }
}
