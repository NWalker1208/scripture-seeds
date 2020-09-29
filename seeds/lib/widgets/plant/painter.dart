import 'dart:ui';
import 'dart:math' as Math;
import 'package:flutter/material.dart';

// Note: All scaling is relative to the height of the canvas
class PlantPainter extends CustomPainter {
  static final double kPlantWidth = 0.03;
  static final double kFruitSize = 0.05;
  static final int kLeafCount = 15;
  static final double kLeafSize = 0.075;
  static final double kLeafCurvature = Math.pi * 0.5;

  static final Path kLeafShape = Path()..addArc(
    Rect.fromCircle(
        center: Offset(0.5, -0.5/Math.tan(kLeafCurvature/2)),
        radius: 0.5/Math.sin(kLeafCurvature/2)
    ),
    Math.pi * 0.5 - kLeafCurvature/2, kLeafCurvature
  )..addArc(
    Rect.fromCircle(
        center: Offset(0.5, 0.5/Math.tan(kLeafCurvature/2)),
        radius: 0.5/Math.sin(kLeafCurvature/2)
    ),
    Math.pi * 1.5 - kLeafCurvature/2, kLeafCurvature
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
    Paint fruit = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;

    canvas.drawCircle(location, size.height * kFruitSize, fruit);
  }

  void _paintLeaf(Canvas canvas, Size size, Color color, Offset location, [double leafScale = 1]) {
    Paint leaf = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    double radius = size.height * kLeafSize * leafScale;

    Path path = Path.from(kLeafShape);
    path = path.transform((Matrix4.identity()..scale(radius)).storage); // Scales leaf
    path = path.shift(location);
    canvas.drawPath(path, leaf);
  }

  // Paints plant graphic
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.height * kPlantWidth;

    Paint stem = Paint()
      ..style = PaintingStyle.stroke
      ..color = (wilted ? Color(0xFFB98D51) : Colors.green)
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    double height = growth;

    Offset start = Offset(size.width / 2, size.height);
    Offset end = Offset(size.width / 2, size.height * (1 - height) + width);

    canvas.drawLine(start, end, stem);

    // Draw leaves
    for (int i = 0; i < kLeafCount; i++) {
      double leafHeight = (i + 1) / (kLeafCount + 0.5);

      if (leafHeight < height) {
        double leafSize = 1;

        // Scale leaves towards top
        if (height - leafHeight < 0.02)
          leafSize = (height - leafHeight) / 0.02;

        // Alternating leaf sides
        if (i.isEven)
          leafSize *= -1;

        _paintLeaf(canvas, size, stem.color, Offset(size.width/2 + width/2 * leafSize.sign, size.height * (1 - leafHeight) + width), leafSize);
      }
    }

    // Draw fruit
    if (fruit)
      _paintFruit(canvas, size, end);
  }

  @override
  bool shouldRepaint(PlantPainter oldDelegate) =>
      oldDelegate.growth != growth ||
      oldDelegate.wilted != wilted ||
      oldDelegate.fruit != fruit;
}
