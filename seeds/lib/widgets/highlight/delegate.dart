import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:built_collection/built_collection.dart';

import 'render.dart';

// Responsible for:
//  - Creating and updating render object

class HighlightParagraphDelegate extends LeafRenderObjectWidget {
  HighlightParagraphDelegate({
    @required this.text,
    Iterable<TextSelection> highlights = const [],
    this.highlightColor,
    this.highlightShape,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.textScaleFactor = 1.0,
    Key key,
  })  : _highlights = highlights.toBuiltList(),
        super(key: key);

  final String text;
  final Color highlightColor;
  final ShapeBorder highlightShape;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final double textScaleFactor;
  final BuiltList<TextSelection> _highlights;
  Iterable<TextSelection> get highlights => _highlights;

  TextStyle _resolveTextStyle(BuildContext context) =>
      textStyle ?? DefaultTextStyle.of(context).style;
  Color _resolveHighlightColor(BuildContext context) =>
      highlightColor ?? Theme.of(context).textSelectionTheme.selectionColor;

  @override
  RenderHighlightParagraph createRenderObject(BuildContext context) =>
      RenderHighlightParagraph(
        text: TextSpan(text: text, style: _resolveTextStyle(context)),
        highlights: highlights,
        highlightColor: _resolveHighlightColor(context),
        highlightShape: highlightShape,
        textAlign: textAlign,
        textScaleFactor: textScaleFactor,
        textDirection: Directionality.of(context),
        locale: Localizations.localeOf(context, nullOk: true),
      );

  @override
  void updateRenderObject(
          BuildContext context, RenderHighlightParagraph renderObject) =>
      renderObject
        ..text = TextSpan(text: text, style: _resolveTextStyle(context))
        ..highlights = highlights
        ..highlightColor = _resolveHighlightColor(context)
        ..highlightShape = highlightShape
        ..textAlign = textAlign
        ..textScaleFactor = textScaleFactor
        ..textDirection = Directionality.of(context)
        ..locale = Localizations.localeOf(context, nullOk: true);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(DiagnosticsProperty('selections', highlights));
    properties.add(ColorProperty('highlightColor', highlightColor));
    properties.add(DiagnosticsProperty('highlightShape', highlightShape));
    properties.add(DiagnosticsProperty('textStyle', textStyle));
    properties.add(DiagnosticsProperty('textAlign', textAlign));
    properties.add(DiagnosticsProperty('textScaleFactor', textScaleFactor));
  }
}
