import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:built_collection/built_collection.dart';

// Responsible for:
//  - Rendering highlights
//  - Animations

class RenderHighlightParagraph extends RenderParagraph {
  RenderHighlightParagraph({
    TextSpan text,
    Iterable<TextSelection> highlights = const [],
    Color highlightColor = Colors.blue,
    ShapeBorder highlightShape,
    TextAlign textAlign = TextAlign.start,
    double textScaleFactor = 1.0,
    @required TextDirection textDirection,
    Locale locale,
  })  : _highlights = highlights.toBuiltList(),
        _highlightColor = highlightColor,
        _highlightShape = highlightShape ?? Border(),
        super(
          text,
          textAlign: textAlign,
          textScaleFactor: textScaleFactor,
          textDirection: textDirection,
          locale: locale,
        );

  BuiltList<TextSelection> _highlights;
  Iterable<TextSelection> get highlights => _highlights;
  set highlights(Iterable<TextSelection> values) {
    var builtValues = values.toBuiltList();
    if (_highlights != builtValues) {
      _highlights = builtValues;
      markNeedsPaint();
    }
  }

  Color _highlightColor;
  Color get highlightColor => _highlightColor;
  set highlightColor(Color value) {
    if (_highlightColor != value) {
      _highlightColor = value;
      markNeedsPaint();
    }
  }

  ShapeBorder _highlightShape;
  ShapeBorder get highlightShape => _highlightShape;
  set highlightShape(ShapeBorder value) {
    if (_highlightShape != value) {
      _highlightShape = value;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    var highlight = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.fill;

    for (var rect in _getHighlightBoxes()) {
      canvas.drawPath(
        highlightShape.getOuterPath(rect, textDirection: textDirection),
        highlight,
      );
    }

    canvas.restore();
    super.paint(context, offset);
  }

  Iterable<Rect> _getHighlightBoxes() => [
        for (var selection in highlights) ...[
          for (var box in getBoxesForSelection(selection))
            Rect.fromLTRB(box.left, box.top, box.right, box.bottom),
        ],
      ];
}
