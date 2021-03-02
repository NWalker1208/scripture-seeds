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
  Widget build(BuildContext context) {
    final progress = Provider.of<ProgressProvider>(context);
    final record = progress.getRecord(name);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: record.progressPercent),
      duration: Duration(milliseconds: 2000),
      curve: Curves.easeInOutCubic,
      builder: (context, growth, child) => Hero(
        tag: 'plant_$name',
        child: _PlantViewDelegate(seed: name, growth: growth, padding: padding),

        // Animate padding between heroes
        flightShuttleBuilder: (_, animation, direction, from, to) {
          if (direction == HeroFlightDirection.pop) {
            animation = ReverseAnimation(animation);
          }
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final viewA = (from.widget as Hero).child as _PlantViewDelegate;
              final viewB = (to.widget as Hero).child as _PlantViewDelegate;
              return _PlantViewDelegate(
                seed: name,
                growth: viewB.growth,
                padding: EdgeInsetsGeometry.lerp(
                  viewA.padding,
                  viewB.padding,
                  animation.value,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Renders the view and the surrounding decorations.
class _PlantViewDelegate extends StatelessWidget {
  const _PlantViewDelegate({
    this.seed,
    this.growth,
    this.padding,
    Key key,
  }) : super(key: key);

  final Object seed;
  final double growth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dayColor = Colors.lightBlue[200];
    final nightColor = Colors.indigo[900];
    final dirtColor = Colors.brown[900];
    //final wiltedColor = Color(0xFFB98D51);

    // Create sky gradient
    final skyColor =
        Theme.of(context).brightness == Brightness.dark ? nightColor : dayColor;
    final sky = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Color.lerp(Theme.of(context).scaffoldBackgroundColor, skyColor, 0.5),
        skyColor,
      ],
      stops: const [0, 1],
    );

    // Create dirt border
    final dirt = Border(
      bottom: BorderSide(
        width: padding.resolve(Directionality.of(context)).bottom,
        color: Color.lerp(
            Theme.of(context).scaffoldBackgroundColor, dirtColor, 0.9),
      ),
    );

    // Build plant view
    // TODO: Account for wilting
    return Container(
      padding: padding,
      decoration: BoxDecoration(gradient: sky),
      foregroundDecoration: BoxDecoration(border: dirt),
      child: PlantWidget(
        seed: seed,
        growth: growth,
        stemColor: Color.lerp(Colors.lightGreen, Colors.brown[600], growth),
        leafColor: Colors.green,
        fruitColor: Colors.red,
      ),
    );
  }
}
