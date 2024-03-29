import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'render.dart';

/// Selection widget responsible for creating and updating the render object.
class SelectionParagraph extends RichText {
  SelectionParagraph({
    @required InlineSpan text,
    Iterable<SelectionDecoration> selectionDecorations = const [],
    TextAlign textAlign = TextAlign.start,
    TextHeightBehavior textHeightBehavior,
    double textScaleFactor = 1.0,
    Key key,
  })  : _selectionDecorations = selectionDecorations.toBuiltList(),
        super(
          key: key,
          text: text,
          textAlign: textAlign,
          textHeightBehavior: textHeightBehavior,
          textScaleFactor: textScaleFactor,
        );

  final BuiltList<SelectionDecoration> _selectionDecorations;
  Iterable<SelectionDecoration> get selectionDecorations => _selectionDecorations;

  @override
  RenderSelectionParagraph createRenderObject(BuildContext context) =>
      RenderSelectionParagraph(
        text: text,
        selectionDecorations: selectionDecorations,
        textAlign: textAlign,
        textHeightBehavior: textHeightBehavior,
        textScaleFactor: textScaleFactor,
        textDirection: Directionality.of(context),
        locale: Localizations.maybeLocaleOf(context),
      );

  @override
  void updateRenderObject(
          BuildContext context, RenderSelectionParagraph renderObject) =>
      renderObject
        ..text = text
        ..selectionDecorations = selectionDecorations
        ..textAlign = textAlign
        ..textHeightBehavior = textHeightBehavior
        ..textScaleFactor = textScaleFactor
        ..textDirection = Directionality.of(context)
        ..locale = Localizations.maybeLocaleOf(context);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('selections', selectionDecorations));
  }
}
