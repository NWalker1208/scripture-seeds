import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/progress/provider.dart';
import 'widget.dart';

class PlantView extends StatelessWidget {
  PlantView(
    this.name, {
    this.padding = const EdgeInsets.all(20),
    Key key,
  }) : super(key: key);

  final String name;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Hero(
        tag: 'plant_$name',
        child: _PlantViewDelegate(name: name, padding: padding),
        flightShuttleBuilder: (context, animation, direction, from, to) {
          final fromView = (from.widget as Hero).child as _PlantViewDelegate;
          final toView = (to.widget as Hero).child as _PlantViewDelegate;

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) => _PlantViewDelegate(
              name: name,
              padding: EdgeInsetsGeometry.lerp(
                fromView.padding,
                toView.padding,
                direction == HeroFlightDirection.push
                    ? animation.value
                    : 1 - animation.value,
              ),
            ),
          );
        },
      );
}

class _PlantViewDelegate extends StatelessWidget {
  const _PlantViewDelegate({
    this.name,
    this.padding,
    Key key,
  }) : super(key: key);

  final String name;
  final EdgeInsetsGeometry padding;

  static final Color kDayColor = Colors.lightBlue[200];
  static final Color kNightColor = Colors.indigo[900];
  Gradient _buildSky(BuildContext context) {
    final skyColor = Theme.of(context).brightness == Brightness.dark
        ? kNightColor
        : kDayColor;
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
  Border _buildDirt(BuildContext context) => Border(
        bottom: BorderSide(
          width: padding.resolve(Directionality.of(context)).bottom,
          color: Color.lerp(
              Theme.of(context).scaffoldBackgroundColor, kDirtColor, 0.9),
        ),
      );

  static final kWiltedColor = Color(0xFFB98D51);
  Widget _buildProgress(BuildContext context) => Consumer<ProgressProvider>(
    builder: (_, progress, __) {
      final record = progress.getRecord(name);
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(end: record.progressPercent),
        duration: Duration(milliseconds: 4000),
        curve: Curves.easeInOutCubic,
        builder: (context, progress, child) => PlantWidget(
          seed: record.id,
          growth: progress,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(gradient: _buildSky(context)),
        foregroundDecoration: BoxDecoration(border: _buildDirt(context)),
        child: _buildProgress(context),
      );
}
