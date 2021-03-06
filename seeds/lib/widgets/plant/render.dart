import 'dart:math';

import 'package:flutter/material.dart';

import '../../extensions/canvas.dart';
import 'branch.dart';

class RenderPlant extends RenderBox {
  RenderPlant(
    PlantBranch root, {
    double scaleOffset = 0,
    double leafScale = 1,
    double fruitScale = 1,
    Color stemColor = Colors.brown,
    Color leafColor = Colors.green,
    Color fruitColor = Colors.red,
  })  : _root = root,
        _scaleOffset = scaleOffset,
        _leafScale = leafScale,
        _fruitScale = fruitScale,
        _stemColor = stemColor,
        _leafColor = leafColor,
        _fruitColor = fruitColor;

  PlantBranch _root;
  double _scaleOffset;
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
    canvas.scale(size.height / 30);
    _paintLeaves(canvas, root);
    _paintBranch(canvas, root);
    canvas.restore();
  }

  double _getLeafScale(double position) {
    final size = 4 * position * (1 - position);
    return size * size * size;
  }

  static const _leafSize = 10.0;
  void _paintLeaves(Canvas canvas, PlantBranch branch) {
    if (leafScale == 0 || branch.scale == 0) return;
    if (branch.scale < scaleOffset || branch.nodes.isEmpty) return;

    var nodes = branch.nodes.where((node) => node.scale >= scaleOffset);

    // Paint children
    for (final node in nodes) {
      for (final branch in node.branches) {
        _paintLeaves(canvas, branch);
      }
    }

    // Skip painting leaves on bottom of trunk
    if (branch == root) nodes = nodes.skip((nodes.length * 0.6).round());

    // Paint leaves of branch
    final leaf = Paint()..color = leafColor;

    var index = 0;
    final count = nodes.length;
    canvas.drawWideLine(
      [
        for (final node in nodes)
          OffsetWidth(
            node.position,
            leafScale *
                (_leafSize *
                        (node.scale - scaleOffset) *
                        _getLeafScale(index++ / count) *
                        (count / root.nodes.length) +
                    0.7),
          ),
      ],
      leaf,
      endCaps: StrokeCap.round,
    );
  }

  static const _branchRadius = 1.0;
  void _paintBranch(Canvas canvas, PlantBranch branch) {
    if (branch.isFruit) return _paintFruit(canvas, branch.origin);
    if (branch.scale < scaleOffset || branch.nodes.isEmpty) return;

    final nodes = branch.nodes.where((node) => node.scale >= scaleOffset);

    // Paint children
    for (final node in nodes) {
      for (final branch in node.branches) {
        _paintBranch(canvas, branch);
      }
    }

    // Paint branch
    final stem = Paint()..color = stemColor;

    canvas.drawWideLine(
      [
        OffsetWidth(
          branch.origin,
          _branchRadius * (branch.scale - scaleOffset),
        ),
        for (final node in nodes)
          OffsetWidth(
            node.position,
            _branchRadius * (node.scale - scaleOffset),
          ),
      ],
      stem,
      initialDirection: branch == root ? pi * 1.5 : null,
    );
  }

  static const _fruitRadius = 0.8;
  void _paintFruit(Canvas canvas, Offset position) {
    if (fruitScale == 0) return;
    final radius = _fruitRadius * fruitScale;
    position += Offset(0, radius * 1.2);
    final rect = Rect.fromCircle(center: position, radius: radius);
    final fruit = Paint()
      ..color = fruitColor
      ..shader = RadialGradient(
        colors: [fruitColor, Color.lerp(Colors.white, fruitColor, 0.75)],
        stops: [0.4, 1],
      ).createShader(rect);

    canvas.drawShadow(Path()..addOval(rect), Colors.black, 2.0, false);
    canvas.drawCircle(position, radius, fruit);
  }
}
