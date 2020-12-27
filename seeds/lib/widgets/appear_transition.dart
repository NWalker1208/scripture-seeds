import 'package:flutter/material.dart';

class AppearTransition extends StatelessWidget {
  final Animation<double> visibility;
  final Curve fadeCurve;
  final Curve sizeCurve;

  final Axis axis;
  final double axisAlignment;
  final Widget child;

  const AppearTransition({
    @required this.visibility,
    this.axis = Axis.vertical,
    this.axisAlignment = 0.0,
    this.fadeCurve = Curves.linear,
    this.sizeCurve = Curves.easeInOut,
    this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: CurvedAnimation(parent: visibility, curve: fadeCurve),
        child: SizeTransition(
          sizeFactor: CurvedAnimation(parent: visibility, curve: sizeCurve),
          axis: axis,
          axisAlignment: axisAlignment,
          child: child,
        ),
      );
}
