import 'dart:ui';
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

class PlantPainter extends CustomPainter {
  final int length;
  final bool wilted;
  final SkyColorMode skyColorMode;

  PlantPainter({
    this.length = 0,
    this.wilted = false,
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

  // Paints sky and ground
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
    canvas.drawRect(rect, background);

    // Draw ground
    Paint ground = Paint()
      ..color = Colors.brown;

    canvas.drawOval(Rect.fromLTRB(
        -75, size.height - 200,
        size.width + 75, size.height + 50
    ), ground);
  }

  // Paints plant graphic
  void _paintForeground(Canvas canvas, Size size) {
    Paint plant = Paint()
      ..style = PaintingStyle.stroke
      ..color = (wilted ? Color(0xFFB98D51) : Colors.green)
      ..strokeWidth = 5;

    Path plantPath = Path();
    plantPath.moveTo(size.width / 2, size.height - 200);

    for (int i = 1; i < length + 1; i++) {
      plantPath.quadraticBezierTo(
          size.width / 2 - 5, size.height - 200 - i * 20.0,
          size.width / 2 - 2, size.height - 190 - i * 20.0);
      plantPath.quadraticBezierTo(
          size.width / 2 + 5, size.height - 200 - i * 20.0,
          size.width / 2 + 2, size.height - 190 - i * 20.0);
    }

    canvas.drawPath(plantPath, plant);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size);
    _paintForeground(canvas, size);
  }

  @override
  bool shouldRepaint(PlantPainter oldDelegate) =>
    oldDelegate.length != length ||
    oldDelegate.wilted != wilted ||
    oldDelegate.skyColorMode != skyColorMode;
}
