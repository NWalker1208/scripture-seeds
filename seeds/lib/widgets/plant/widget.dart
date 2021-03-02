import 'package:flutter/material.dart';

import 'branch.dart';
import 'render.dart';

class PlantWidget extends LeafRenderObjectWidget {
  PlantWidget({
    @required this.seed,
    this.growth = 1.0,
    Key key,
  }) : super(key: key);

  final Object seed;
  final double growth;

  @override
  RenderPlant createRenderObject(BuildContext context) => RenderPlant(
        PlantBranch.generate(seed),
        scaleOffset: 1 - growth,
        stemColor: Colors.green,
      );

  @override
  void updateRenderObject(BuildContext context, RenderPlant renderObject) {
    renderObject
      ..root = PlantBranch.generate(seed)
      ..scaleOffset = 1 - growth
      ..stemColor = Colors.green;
  }
}
