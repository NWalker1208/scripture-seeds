import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../../extensions/random.dart';

@immutable
class PlantBranch {
  PlantBranch(this.origin, this.scale, Iterable<PlantNode> nodes)
      : _nodes = nodes.toBuiltList();

  static final _genCache = <int, PlantBranch>{};
  factory PlantBranch.generate(Object seed) {
    final hash = seed.hashCode;
    // Do not use cache during debug.
    assert(() {
      _genCache.clear();
      return true;
    }());
    // Generate or copy from cache.
    return _genCache[hash] ??= PlantBranch._generate(Random(hash));
  }

  factory PlantBranch._generate(
    Random random, {
    Offset origin = Offset.zero,
    double scale = 1,
    double direction = pi * 1.5,
  }) {
    // Generate nodes
    final nodeCount = (scale * random.nextInRange(42, 48)).round();
    var offset = origin;
    var tilt = 0.0;
    final nodes = <PlantNode>[
      for (var i = 1; i <= nodeCount; i++)
        PlantNode._generate(random, scale,
            position: offset += Offset.fromDirection(direction +
                (tilt = 0.6 * (tilt + pi * random.nextInRange(-0.3, 0.3)))),
            branchPosition: i / nodeCount,
            direction: direction + tilt),
    ];
    // Create branch
    return PlantBranch(origin, scale, nodes);
  }

  final Offset origin;
  final double scale;
  final BuiltList<PlantNode> _nodes;
  Iterable<PlantNode> get nodes => _nodes;

  @override
  String toString() => '(${origin.dx},${origin.dy}): $nodes';
}

@immutable
class PlantNode {
  PlantNode(this.position, this.branchPosition, Iterable<PlantBranch> branches)
      : _branches = branches.toBuiltList();

  factory PlantNode._generate(
    Random random,
    double branchScale, {
    Offset position,
    double branchPosition,
    double direction,
  }) {
    final nodeScale = branchScale * (1 - branchPosition);
    // Maybe generate branch
    final branchProb = pow(4 * nodeScale * branchPosition, 4);
    final fruitProb =
        1 - 4 * ((direction + pi / 2).remainder(pi) - pi / 2).abs() / pi;
    final branches = <PlantBranch>[
      if (random.nextChance(0.8 * branchProb))
        PlantBranch._generate(random,
            origin: position,
            scale: nodeScale * branchProb * random.nextInRange(0.6, 0.9),
            direction: direction +
                pi * random.nextInRange(0.25, 0.45) * random.nextSign()),
      if (random.nextChance(0.2 * fruitProb)) PlantBranch(position, 0, []),
    ];
    // Create node
    return PlantNode(position, branchPosition, branches);
  }

  final Offset position;
  final double branchPosition;
  final BuiltList<PlantBranch> _branches;
  Iterable<PlantBranch> get branches => _branches;

  @override
  String toString() =>
      '($branchPosition/1.0, (${position.dx}, ${position.dy}), branches: $branches)';
}
