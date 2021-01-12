import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RenderPlant extends RenderBox {
  /// Width of stem in percent of [size.height].
  static const double _kStemWidth = 0.03;

  /// Total number of leaves.
  static const int _kLeafCount = 15;

  /// Length of leaf in percent of [size.height].
  static const double _kLeafLength = 0.075;

  /// Radius of leaf curvature in percent of [size.height].
  static const double _kLeafRadius = 0.05;

  /// Distance at which leaves taper in size.
  /// Measured in percent of [size.height].
  static const double _kLeafTaperDistance = 0.02;

  /// Radius of fruit in percent of [size.height].
  static const double _kFruitSize = 0.05;

  /// Color of fruit.
  static const Color _kFruitColor = Color(0xFFDD0000);

  RenderPlant({
    double growth = 0,
    Color color = Colors.green,
    bool hasFruit = false,
    Gradient skyGradient,
    Color dirtColor,
    EdgeInsets padding,
  })  : _growth = growth,
        _color = color,
        _hasFruit = hasFruit,
        _skyGradient = skyGradient,
        _dirtColor = dirtColor,
        _padding = padding;

  double _growth;
  double get growth => _growth;
  set growth(double value) {
    if (_growth != value) {
      _growth = value;
      markNeedsPaint();
    }
  }

  Color _color;
  Color get color => _color;
  set color(Color value) {
    if (_color != value) {
      _color = value;
      markNeedsPaint();
    }
  }

  bool _hasFruit;
  bool get hasFruit => _hasFruit;
  set hasFruit(bool value) {
    if (_hasFruit == value) {
      _hasFruit = value;
      markNeedsPaint();
    }
  }

  Gradient _skyGradient;
  Gradient get skyGradient => _skyGradient;
  set skyGradient(Gradient value) {
    if (_skyGradient != value) {
      _skyGradient = value;
      markNeedsPaint();
    }
  }

  Color _dirtColor;
  Color get dirtColor => _dirtColor;
  set dirtColor(Color value) {
    if (_dirtColor != value) {
      _dirtColor = value;
      markNeedsPaint();
    }
  }

  EdgeInsets _padding;
  EdgeInsets get padding => _padding;
  set padding(EdgeInsets value) {
    if (_padding != value) {
      _padding = value;
      markNeedsPaint();
    }
  }

  Shader get _skyShader => skyGradient.createShader(Offset.zero & size);
  double get _dirtHeight => padding.bottom;

  Offset get _stemStart => size.bottomCenter(Offset(0, -padding.bottom));
  Offset get _stemEnd => _stemStart.translate(0, -_maxStemHeight * growth);
  double get _stemWidth => size.height * _kStemWidth;
  double get _maxStemHeight => size.height - padding.vertical;

  int get _leafCount => _kLeafCount;
  double get _leafLength => size.height * _kLeafLength;
  double get _leafRadius => size.height * _kLeafRadius;
  double _leafScale(double height) =>
      math.min(1.0, (growth - height) / _kLeafTaperDistance);

  double get _fruitRadius => size.height * _kFruitSize;
  Color get _fruitColor => _kFruitColor;

  @override
  bool get sizedByParent => true;

  @override
  void performResize() => size = constraints.biggest;

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    _paintSky(canvas);
    _paintStem(canvas);
    _paintLeaves(canvas);
    if (hasFruit) _paintFruit(canvas);
    _paintDirt(canvas);

    canvas.restore();
  }

  void _paintSky(Canvas canvas) {
    final sky = Paint()
      ..style = PaintingStyle.fill
      ..shader = _skyShader;

    canvas.drawRect(Offset.zero & size, sky);
  }

  void _paintDirt(Canvas canvas) {
    final dirt = Paint()
      ..style = PaintingStyle.fill
      ..color = dirtColor;

    final rect = Rect.fromPoints(size.bottomLeft(Offset.zero),
        size.bottomRight(Offset(0, -_dirtHeight)));

    canvas.drawRect(rect, dirt);
  }

  void _paintStem(Canvas canvas) {
    final stem = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = _stemWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(_stemStart, _stemEnd, stem);
  }

  void _paintLeaves(Canvas canvas) {
    for (var i = 0; i < _leafCount; i++) {
      final height = (i + 1.0) / (_leafCount + 0.5);
      if (height >= growth) break;

      final scale = (i.isEven ? -1.0 : 1.0) * _leafScale(height);
      final offset = _stemStart.translate(
        _stemWidth / 2 * scale.sign,
        -_maxStemHeight * height,
      );

      _paintLeaf(canvas, offset, scale);
    }
  }

  void _paintLeaf(Canvas canvas, Offset offset, [double scale = 1]) {
    final leaf = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final length = _leafLength * scale;
    final radius = _leafRadius * scale;
    final path = Path()
      ..moveTo(offset.dx, offset.dy)
      ..relativeArcToPoint(Offset(length, 0), radius: Radius.circular(radius))
      ..relativeArcToPoint(Offset(-length, 0), radius: Radius.circular(radius));

    canvas.drawPath(path, leaf);
  }

  void _paintFruit(Canvas canvas) {
    final fruit = Paint()
      ..style = PaintingStyle.fill
      ..color = _fruitColor;

    canvas.drawCircle(_stemEnd, _fruitRadius, fruit);
  }
}
