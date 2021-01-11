import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:built_collection/built_collection.dart';

import 'render.dart';

// Responsible for:
//  - Creating and updating render object

class SelectionParagraph extends RichText {
  SelectionParagraph({
    @required InlineSpan text,
    Iterable<SelectionDecoration> selections = const [],
    TextAlign textAlign = TextAlign.start,
    double textScaleFactor = 1.0,
    Key key,
  })  : _selections = selections.toBuiltList(),
        super(
          key: key,
          text: text,
          textAlign: textAlign,
          textScaleFactor: textScaleFactor,
        );

  final BuiltList<SelectionDecoration> _selections;
  Iterable<SelectionDecoration> get selections => _selections;

  @override
  RenderSelectionParagraph createRenderObject(BuildContext context) =>
      RenderSelectionParagraph(
        text: text,
        selections: selections,
        textAlign: textAlign,
        textScaleFactor: textScaleFactor,
        textDirection: Directionality.of(context),
        locale: Localizations.localeOf(context, nullOk: true),
      );

  @override
  void updateRenderObject(
          BuildContext context, RenderSelectionParagraph renderObject) =>
      renderObject
        ..text = text
        ..selections = selections
        ..textAlign = textAlign
        ..textScaleFactor = textScaleFactor
        ..textDirection = Directionality.of(context)
        ..locale = Localizations.localeOf(context, nullOk: true);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('selections', selections));
  }
}
