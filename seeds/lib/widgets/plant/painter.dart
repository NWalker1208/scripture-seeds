import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

// Note: All scaling is relative to the height of the canvas
class PlantPainter extends CustomPainter {
  static final double kPlantWidth = 0.03;
  static final double kFruitSize = 0.05;
  static final int kLeafCount = 15;
  static final double kLeafSize = 0.075;
  static final double kLeafCurvature = math.pi * 0.5;

  static final Path kLeafShape = Path()
    ..addArc(
      Rect.fromCircle(
        center: Offset(0.5, -0.5 / math.tan(kLeafCurvature / 2)),
        radius: 0.5 / math.sin(kLeafCurvature / 2),
      ),
      math.pi * 0.5 - kLeafCurvature / 2,
      kLeafCurvature,
    )
    ..addArc(
      Rect.fromCircle(
        center: Offset(0.5, 0.5 / math.tan(kLeafCurvature / 2)),
        radius: 0.5 / math.sin(kLeafCurvature / 2),
      ),
      math.pi * 1.5 - kLeafCurvature / 2,
      kLeafCurvature,
    );

  final double growth;
  final bool wilted;
  final bool fruit;

  PlantPainter({
    this.growth = 0,
    this.wilted = false,
    this.fruit = false,
  });

  // Paints fruit graphic
  void _paintFruit(Canvas canvas, Size size, Offset location) {
    var fruit = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;

    canvas.drawCircle(location, size.height * kFruitSize, fruit);
  }

  void _paintLeaf(Canvas canvas, Size size, Color color, Offset location,
      [double leafScale = 1]) {
    var leaf = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    var radius = size.height * kLeafSize * leafScale;

    var path = Path.from(kLeafShape);
    path = path
        .transform((Matrix4.identity()..scale(radius)).storage); // Scales leaf
    path = path.shift(location);
    canvas.drawPath(path, leaf);
  }

  // Paints plant graphic
  @override
  void paint(Canvas canvas, Size size) {
    var width = size.height * kPlantWidth;

    var stem = Paint()
      ..style = PaintingStyle.stroke
      ..color = (wilted ? Color(0xFFB98D51) : Colors.green)
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    var height = growth;

    var start = Offset(size.width / 2, size.height);
    var end = Offset(size.width / 2, size.height * (1 - height) + width);

    canvas.drawLine(start, end, stem);

    // Draw leaves
    for (var i = 0; i < kLeafCount; i++) {
      var leafHeight = (i + 1) / (kLeafCount + 0.5);

      if (leafHeight < height) {
        var leafSize = 1.0;

        // Scale leaves towards top
        if (height - leafHeight < 0.02) leafSize = (height - leafHeight) / 0.02;

        // Alternating leaf sides
        if (i.isEven) leafSize *= -1;

        _paintLeaf(
          canvas,
          size,
          stem.color,
          Offset(size.width / 2 + width / 2 * leafSize.sign,
              size.height * (1 - leafHeight) + width),
          leafSize,
        );
      }
    }

    // Draw fruit
    if (fruit) _paintFruit(canvas, size, end);
  }

  @override
  bool shouldRepaint(PlantPainter oldDelegate) =>
      oldDelegate.growth != growth ||
      oldDelegate.wilted != wilted ||
      oldDelegate.fruit != fruit;
}
