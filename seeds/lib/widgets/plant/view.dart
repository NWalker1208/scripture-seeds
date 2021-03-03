import 'dart:ui';

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

  Widget _buildHero(double growth, double fruit, double wilt) => Hero(
        tag: 'plant_$name',
        child: _PlantViewDelegate(
          seed: name,
          growth: growth,
          fruit: fruit,
          wilt: wilt,
          padding: padding,
        ),

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
              final val = animation.value;
              return _PlantViewDelegate(
                seed: name,
                growth: lerpDouble(viewA.growth, viewB.growth, val),
                fruit: lerpDouble(viewA.fruit, viewB.fruit, val),
                wilt: lerpDouble(viewA.wilt, viewB.wilt, val),
                padding: EdgeInsetsGeometry.lerp(
                  viewA.padding,
                  viewB.padding,
                  val,
                ),
              );
            },
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final progress = Provider.of<ProgressProvider>(context);
    final record = progress.getRecord(name);

    Widget growthAnimation(double fruit, double wilt) =>
        TweenAnimationBuilder<double>(
          tween: Tween(end: record.progressPercent),
          duration: Duration(milliseconds: 2000),
          curve: Curves.easeInOutCubic,
          builder: (_, growth, __) => _buildHero(growth, fruit, wilt),
        );

    Widget fruitAnimation(double wilt) => TweenAnimationBuilder<double>(
          tween: Tween(end: record.rewardAvailable ? 1 : 0),
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeOut,
          builder: (_, fruit, __) => growthAnimation(fruit, wilt),
        );

    // Wilt animation
    return TweenAnimationBuilder<double>(
      tween: Tween(end: record.progressLost?.toDouble() ?? -1),
      duration: Duration(milliseconds: 2000),
      curve: Curves.easeInOutCubic,
      builder: (_, wilt, __) => fruitAnimation(wilt),
    );
  }
}

// Renders the view and the surrounding decorations.
class _PlantViewDelegate extends StatelessWidget {
  const _PlantViewDelegate({
    this.seed,
    this.growth,
    this.wilt,
    this.fruit,
    this.padding,
    Key key,
  }) : super(key: key);

  final Object seed;
  final double growth;
  final double wilt;
  final double fruit;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // Background colors
    final dayColor = Colors.lightBlue[200];
    final nightColor = Colors.indigo[900];
    final dirtColor = Colors.brown[900];

    // Foreground colors
    final stemColor = Colors.lightGreen;
    final trunkColor = Colors.brown[500];
    final leafColor = Colors.green[700];
    final fruitColor = Colors.red;
    final wiltedStemColor = Colors.brown;
    final wiltedLeafColor = Color(0xFFB98D51);

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
    final colorGrowth = (4 * growth - 1.5).clamp(0, 1).toDouble();
    final colorWilt = (wilt + 1).clamp(0, 1).toDouble();
    final leafWilt = (1 - wilt / 2).clamp(0, 1).toDouble();
    return Container(
      padding: padding,
      decoration: BoxDecoration(gradient: sky),
      foregroundDecoration: BoxDecoration(border: dirt),
      child: PlantWidget(
        seed: seed,
        growth: growth,
        leafScale: leafWilt,
        fruitScale: fruit,
        stemColor: Color.lerp(
          Color.lerp(stemColor, trunkColor, colorGrowth),
          wiltedStemColor,
          colorWilt,
        ),
        leafColor: Color.lerp(leafColor, wiltedLeafColor, colorWilt),
        fruitColor: fruitColor,
      ),
    );
  }
}
