import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'branch.dart';

class RenderPlant extends RenderBox {
  RenderPlant(
    PlantBranch root, {
    double scaleOffset = 0,
    double minScale = 0.1,
    double leafScale = 1,
    double fruitScale = 1,
    Color stemColor = Colors.brown,
    Color leafColor = Colors.green,
    Color fruitColor = Colors.red,
  })  : _root = root,
        _scaleOffset = scaleOffset,
        _minScale = minScale,
        _leafScale = leafScale,
        _fruitScale = fruitScale,
        _stemColor = stemColor,
        _leafColor = leafColor,
        _fruitColor = fruitColor;

  PlantBranch _root;
  double _scaleOffset;
  double _minScale;
  double _leafScale;
  double _fruitScale;
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

  /// The scale multiplier for leaves. Leaves are not rendered if this equals 0.
  double get leafScale => _leafScale;
  set leafScale(double value) {
    if (_leafScale == value) return;
    _leafScale = value;
    markNeedsPaint();
  }

  /// The scale multiplier for fruit. Fruit are not rendered if this equals 0.
  double get fruitScale => _fruitScale;
  set fruitScale(double value) {
    if (_fruitScale == value) return;
    _fruitScale = value;
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
    canvas.scale(size.height / 25);
    _paintBranch(canvas, root);
    canvas.restore();
  }

  double _getLeafScale(double position) {
    final size = 4 * position * (1 - position);
    return size * size * size;
  }

  void _paintBranch(Canvas canvas, PlantBranch branch) {
    // Check if branch represents fruit
    if (branch.scale == 0) {
      _paintFruit(canvas, branch.origin);
    }

    // Paint leaves
    if (leafScale > 0) {
      var index = 1;
      final count = branch.nodes.length;
      for (final node in branch.nodes) {
        final nodeScale = node.scale - scaleOffset;
        if (nodeScale < minScale) break;

        if (branch != root) {
          final scale = _getLeafScale(index / count);
          _paintLeaf(canvas, node.position, scale * nodeScale);
        } else if (index > count * 0.75) {
          final scale = _getLeafScale(index / count);
          _paintLeaf(canvas, node.position, scale * nodeScale * 0.8);
        }
        index++;
      }
    }

    // Paint branch
    if (branch.scale - scaleOffset < minScale) return;
    var pos = branch.origin;
    for (final node in branch.nodes) {
      final nodeScale = node.scale - scaleOffset;
      if (nodeScale < minScale) break;

      final stem = Paint()
        ..color = stemColor
        ..strokeWidth = nodeScale * 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(pos, node.position, stem);
      for (final branch in node.branches) {
        _paintBranch(canvas, branch);
      }
      pos = node.position;
    }
  }

  void _paintLeaf(Canvas canvas, Offset position, double scale) {
    final leaf = Paint()
      ..color = leafColor
      ..style = PaintingStyle.fill;

    scale = max(scale, 0.1);
    canvas.drawCircle(position, 8 * scale * leafScale, leaf);
  }

  void _paintFruit(Canvas canvas, Offset position) {
    final fruit = Paint()
      ..color = fruitColor
      ..style = PaintingStyle.fill;

    final radius = 0.8 * fruitScale;
    canvas.drawCircle(position + Offset(0, radius * 1.2), radius, fruit);
  }
}
