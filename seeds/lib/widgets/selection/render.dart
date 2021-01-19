import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Responsible for:
//  - Rendering highlights
//  - Animations

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

class RenderSelectionParagraph extends RenderParagraph {
  RenderSelectionParagraph({
    InlineSpan text,
    Iterable<SelectionDecoration> selections,
    TextAlign textAlign = TextAlign.start,
    TextHeightBehavior textHeightBehavior,
    double textScaleFactor = 1.0,
    @required TextDirection textDirection,
    Locale locale,
  })  : _selections = selections.toBuiltList(),
        super(
          text,
          textAlign: textAlign,
          textHeightBehavior: textHeightBehavior,
          textScaleFactor: textScaleFactor,
          textDirection: textDirection,
          locale: locale,
        );

  BuiltList<SelectionDecoration> _selections;
  Iterable<SelectionDecoration> get selections => _selections;
  set selections(Iterable<SelectionDecoration> values) {
    var builtValues = values.toBuiltList();
    if (_selections != builtValues) {
      _selections = builtValues;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    for (var selection in selections) {
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
