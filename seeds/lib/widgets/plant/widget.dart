import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'render.dart';

class PlantWidget extends LeafRenderObjectWidget {
  PlantWidget({
    this.growth = 1.0,
    this.wilted = false,
    this.hasFruit = false,
    this.padding = EdgeInsets.zero,
    Key key,
  }) : super(key: key);

  final double growth;
  final bool wilted;
  final bool hasFruit;
  final EdgeInsetsGeometry padding;

  Color get color => wilted ? Color(0xFFB98D51) : Colors.green;

  static final Color kDayColor = Colors.lightBlue[200];
  static final Color kNightColor = Colors.indigo[900];
  Color _getSkyColor(double light) => Color.lerp(kNightColor, kDayColor, light);

  Gradient _getSkyGradient(BuildContext context) {
    final skyColor = Theme.of(context).brightness == Brightness.dark
        ? _getSkyColor(0)
        : _getSkyColor(1);
    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Color.lerp(Theme.of(context).scaffoldBackgroundColor, skyColor, 0.5),
        skyColor,
      ],
      stops: const [0, 1],
    );
  }

  static final Color kDirtColor = Colors.brown[900];
  Color _getDirtColor(BuildContext context) =>
      Color.lerp(Theme.of(context).scaffoldBackgroundColor, kDirtColor, 0.9);

  @override
  RenderPlant createRenderObject(BuildContext context) => RenderPlant(
        growth: growth,
        color: color,
        hasFruit: hasFruit,
        skyGradient: _getSkyGradient(context),
        dirtColor: _getDirtColor(context),
        padding: padding.resolve(Directionality.of(context)),
      );

  @override
  void updateRenderObject(BuildContext context, RenderPlant renderObject) {
    renderObject
      ..growth = growth
      ..color = color
      ..hasFruit = hasFruit
      ..skyGradient = _getSkyGradient(context)
      ..dirtColor = _getDirtColor(context)
      ..padding = padding.resolve(Directionality.of(context));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('growth', growth));
    properties.add(FlagProperty('wilted', value: wilted, ifTrue: 'wilted'));
    properties.add(FlagProperty('hasFruit', value: hasFruit, ifTrue: 'fruit'));
    properties.add(DiagnosticsProperty('padding', padding));
  }
}
