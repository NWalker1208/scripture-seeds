import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'branch.dart';

class RenderPlant extends RenderBox {
  RenderPlant(
    PlantBranch root, {
    double scaleOffset = 0,
    double minScale = 0.1,
    Color stemColor = Colors.brown,
    Color leafColor = Colors.green,
    Color fruitColor = Colors.red,
  })  : _root = root,
        _scaleOffset = scaleOffset,
        _minScale = minScale,
        _stemColor = stemColor,
        _leafColor = leafColor,
        _fruitColor = fruitColor;

  PlantBranch _root;
  double _scaleOffset;
  double _minScale;
  Color _stemColor;
  Color _leafColor;
  Color _fruitColor;

  /// The root of the plant to render.
  PlantBranch get root => _root;
  set root(PlantBranch value) {
    if (_root == value) return;
    _root = value;
    markNeedsPaint();
  }

  /// Reduces the scale of all PlantNodes. Hides any nodes that end up smaller
  /// than zero.
  double get scaleOffset => _scaleOffset;
  set scaleOffset(double value) {
    if (_scaleOffset == value) return;
    _scaleOffset = value;
    markNeedsPaint();
  }

  /// The smallest scale a node or branch must have to be drawn.
  double get minScale => _minScale;
  set minScale(double value) {
    if (_minScale == value) return;
    _minScale = value;
    markNeedsPaint();
  }

  /// The color of the stem/trunk.
  Color get stemColor => _stemColor;
  set stemColor(Color value) {
    if (_stemColor == value) return;
    _stemColor = value;
    markNeedsPaint();
  }

  /// The color of the leaves.
  Color get leafColor => _leafColor;
  set leafColor(Color value) {
    if (_leafColor == value) return;
    _leafColor = value;
    markNeedsPaint();
  }

  /// The color of the fruit.
  Color get fruitColor => _fruitColor;
  set fruitColor(Color value) {
    if (_fruitColor == value) return;
    _fruitColor = value;
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() => size = constraints.biggest;

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.translate(size.width / 2, size.height);
    canvas.scale(size.height / 48);
    _paintBranch(canvas, size, root);
    canvas.restore();
  }

  void _paintBranch(Canvas canvas, Size size, PlantBranch branch) {
    if (branch.scale - scaleOffset < minScale) {
      final leaf = Paint()
        ..color = leafColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(branch.origin, 0.2, leaf);
      return;
    }

    var pos = branch.origin;
    for (final node in branch.nodes) {
      final nodeScale = branch.scale * (1 - node.branchPosition) - scaleOffset;
      if (nodeScale < minScale) break;
      final stem = Paint()
        ..color = stemColor
        ..strokeWidth = nodeScale
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(pos, node.position, stem);
      for (final branch in node.branches) {
        _paintBranch(canvas, size, branch);
      }
      pos = node.position;
    }
  }
}
