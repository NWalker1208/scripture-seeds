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

  @override
  Widget build(BuildContext context) => Consumer<ProgressProvider>(
        builder: (_, progress, __) {
          final record = progress.getRecord(name);
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: record.progressPercent),
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOutCubic,
            builder: (context, progress, child) => PlantWidget(
              growth: progress,
              wilted: record.progressLost != null,
              hasFruit: record.rewardAvailable,
              padding: padding,
            ),
          );
        },
      );
}
