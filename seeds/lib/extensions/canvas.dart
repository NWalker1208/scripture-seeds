import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class OffsetWidth {
  const OffsetWidth(this.offset, this.width);

  final Offset offset;
  final double width;
}

extension CanvasExtension on Canvas {
  void drawWideLine(
    Iterable<OffsetWidth> points,
    Paint paint, {
    double initialDirection,
    StrokeCap endCaps = StrokeCap.butt,
  }) {
    if (points.length < 2) return;
    final line = points.toList();
    final vertices = <Offset>[];

    Offset previous;
    if (initialDirection != null) {
      previous = Offset.fromDirection(initialDirection);
    } else {
      previous = line[1].offset - line[0].offset;
      previous /= previous.distance;
    }

    for (var i = 0; i < line.length; i++) {
      Offset current;
      if (i == 0 || i == line.length - 1) {
        current = previous;
      } else {
        current = line[i + 1].offset - line[i].offset;
        current /= current.distance;
      }

      final direction = (current + previous).direction + pi / 2;
      final offset = Offset.fromDirection(direction, line[i].width);
      final position = line[i].offset;
      vertices.insert(0, position - offset);
      vertices.add(position + offset);
      // Replace when drawVertices works properly
      //vertices.addAll([position - offset, position + offset]);

      previous = current;
    }

    if (endCaps == StrokeCap.square) {
      throw UnimplementedError('Square caps not implemented yet.');
    }

    drawPath(Path()..addPolygon(vertices, true), paint);
    // Draw vertices is broken on some platforms. Switch back when patched.
    /*drawVertices(
      Vertices(VertexMode.triangleStrip, vertices),
      BlendMode.srcOver,
      paint,
    );*/

    if (endCaps == StrokeCap.round && line.last.width > 0) {
      _drawEndCap(line.first, line[1], paint);
      _drawEndCap(line.last, line[line.length - 2], paint);
    }
  }

  void _drawEndCap(OffsetWidth end, OffsetWidth previous, Paint paint) {
    final vector = end.offset - previous.offset;
    // Calculate the arc angle
    final widthChange = end.width - previous.width;
    final arc = pi + atan(widthChange / vector.distance);
    // Calculate center
    final direction = vector.direction;
    final offsetDistance = tan((pi - arc) / 2) * end.width + 0.025;
    final offset = Offset.fromDirection(direction, offsetDistance);
    final center = end.offset - offset;
    // Draw the arc
    final edgeCount = (5 * arc / pi).ceil();
    final vertices = [
      for (int i = 0; i < edgeCount; i++)
        center +
            Offset.fromDirection(
              direction + arc * (i / (edgeCount - 1) - 0.5),
              end.width,
            ),
    ];
    drawPath(Path()..addPolygon(vertices, true), paint);
    // Draw vertices is broken on some platforms. Switch back when patched.
    /*drawVertices(
      Vertices(VertexMode.triangleFan, vertices),
      BlendMode.srcOver,
      paint,
    );*/
  }

  /// Draws the given vertices as a wireframe.
  void drawDebugVertices(List<Offset> vertices, Color color) {
    print('Painting ${vertices.length} with color $color');
    final debugPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.15;
    drawPoints(
      PointMode.points,
      vertices,
      debugPaint,
    );
    debugPaint.strokeWidth = 0;
    for (var i = 0; i < vertices.length - 2; i++) {
      drawPoints(
        PointMode.polygon,
        [vertices[i], vertices[i + 1], vertices[i + 2], vertices[i]],
        debugPaint,
      );
    }
  }
}
