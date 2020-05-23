import 'package:flutter/material.dart';

class PlantPainter extends CustomPainter {
  final int length;

  PlantPainter(this.length);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw ground
    Paint ground = Paint()
      ..color = Colors.brown;

    canvas.drawOval(Rect.fromLTRB(-75, size.height - 200, size.width + 75, size.height + 50), ground);

    // Draw plant
    Paint plant = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.green
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
  bool shouldRepaint(PlantPainter oldDelegate) => oldDelegate.length != length;
}
