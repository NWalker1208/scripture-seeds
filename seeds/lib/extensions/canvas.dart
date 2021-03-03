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
      vertices.addAll([position + offset, position - offset]);

      previous = current;
    }

    if (endCaps == StrokeCap.square) {
      throw UnimplementedError('Square caps not implemented yet.');
    }

    drawVertices(
      Vertices(VertexMode.triangleStrip, vertices),
      BlendMode.srcOver,
      paint,
    );

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
    final offset =
        Offset.fromDirection(direction, tan((pi - arc) / 2));
    final center = end.offset - offset * end.width;
    // Draw the arc
    final edges = (10 * arc / pi).ceil();
    drawVertices(
      Vertices(VertexMode.triangleFan, [
        for (int i = 0; i < edges; i++)
          center +
              Offset.fromDirection(direction + arc * (i / (edges - 1) - 0.5)) *
                  end.width,
      ]),
      BlendMode.srcOver,
      paint,
    );
  }
}
