import 'dart:ui';
import 'dart:math' as Math;
import 'package:flutter/material.dart';

enum SkyColorMode {
  time,
  light,
  dark
}

class _ColorPair {
  Color bottom;
  Color top;

  _ColorPair({this.bottom = Colors.blue, this.top = Colors.blue});
}

// Note: All scaling is relative to the height of the canvas
class PlantPainter extends CustomPainter {
  static final double kGroundHeight = 0.15;
  static final double kMaxPlantHeight = 0.8;
  static final double kPlantWidth = 0.02;
  static final double kFruitSize = 0.05;
  static final int kLeafCount = 15;
  static final double kLeafSize = 0.05;
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
  final SkyColorMode skyColorMode;

  PlantPainter({
    this.growth = 0,
    this.wilted = false,
    this.fruit = false,
    this.skyColorMode = SkyColorMode.time
  });

  _ColorPair getSkyColors() {
    _ColorPair colors;

    if (skyColorMode == SkyColorMode.light)
      colors = _ColorPair(
        top: Colors.lightBlue[100],
        bottom: Colors.lightBlue[200]
      );

    else if (skyColorMode == SkyColorMode.dark)
      colors = _ColorPair(
          top: Colors.indigo[800],
          bottom: Colors.indigo[900]
      );

    else if (skyColorMode == SkyColorMode.time)
      colors = _ColorPair(
          top: Colors.lightBlue[100],
          bottom: Colors.lightBlue[200]
      );

    return colors;
  }

  // Paints sky
  void _paintBackground(Canvas canvas, Size size) {
    _ColorPair sky = getSkyColors();

    Rect rect = Offset.zero & size;
    Gradient gradient = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [sky.bottom, sky.top],
        stops: [0, 1]
    );

    Paint background = Paint()
      ..shader = gradient.createShader(rect);
    canvas.drawPaint(background);
  }

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
  void _paintPlant(Canvas canvas, Size size) {
    double width = size.height * kPlantWidth;

    Paint stem = Paint()
      ..style = PaintingStyle.stroke
      ..color = (wilted ? Color(0xFFB98D51) : Colors.green)
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    double height = kGroundHeight - (kGroundHeight - kMaxPlantHeight) * growth;

    Offset start = Offset(size.width / 2, size.height * (1 - kGroundHeight) + width);
    Offset end = Offset(size.width / 2, size.height * (1 - height) + width);

    canvas.drawLine(start, end, stem);

    // Draw leaves
    for (int i = 0; i < kLeafCount; i++) {
      double leafHeight = kGroundHeight - (kGroundHeight - kMaxPlantHeight) * ((i + 1) / (kLeafCount + 0.5));

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

  // Draw ground
  void _paintGround(Canvas canvas, Size size) {
    Paint ground = Paint()
      ..color = Colors.brown[800];

    canvas.drawRect(Rect.fromLTRB(
      0, size.height * (1 - kGroundHeight),
      size.width, size.height
    ), ground);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset(0, 0) & size);

    _paintBackground(canvas, size);
    _paintPlant(canvas, size);
    _paintGround(canvas, size);
  }

  @override
  bool shouldRepaint(PlantPainter oldDelegate) =>
      oldDelegate.growth != growth ||
      oldDelegate.wilted != wilted ||
      oldDelegate.fruit != fruit ||
      oldDelegate.skyColorMode != skyColorMode;
}
