import 'package:flutter/material.dart';

import 'branch.dart';
import 'render.dart';

class PlantWidget extends LeafRenderObjectWidget {
  PlantWidget({
    @required this.seed,
    this.growth = 1.0,
    this.leafScale = 1.0,
    this.fruitScale = 1.0,
    this.stemColor = Colors.brown,
    this.leafColor = Colors.green,
    this.fruitColor = Colors.red,
    Key key,
  }) : super(key: key);

  final Object seed;
  final double growth;
  final double leafScale;
  final double fruitScale;
  final Color stemColor;
  final Color leafColor;
  final Color fruitColor;

  @override
  RenderPlant createRenderObject(BuildContext context) => RenderPlant(
        PlantBranch.generate(seed),
        scaleOffset: 1 - growth,
        leafScale: leafScale,
        fruitScale: fruitScale,
        stemColor: stemColor,
        leafColor: leafColor,
        fruitColor: fruitColor,
      );

  @override
  void updateRenderObject(BuildContext context, RenderPlant renderObject) {
    renderObject
      ..root = PlantBranch.generate(seed)
      ..scaleOffset = 1 - growth
      ..leafScale = leafScale
      ..fruitScale = fruitScale
      ..stemColor = stemColor
      ..leafColor = leafColor
      ..fruitColor = fruitColor;
  }
}
