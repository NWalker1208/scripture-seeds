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
    final nodeCount = (scale * random.nextInRange(24, 32)).round();

    double fruitProbability(int index, double direction) {
      final position = index / nodeCount;
      final angle = ((direction + pi / 2).remainder(pi) - pi / 2).abs();
      final fromPosition = 4 * position * (1 - position);
      final fromAngle = 2 * angle / (pi / 2);
      return 0.6 * (fromPosition * fromPosition - fromAngle);
    }

    var offset = origin;
    var tilt = 0.0;
    final nodes = <PlantNode>[
      for (var i = 1; i <= nodeCount; i++)
        PlantNode._generate(
          random,
          position: offset += Offset.fromDirection(direction +
              (tilt = 0.6 * (tilt + pi * random.nextInRange(-0.25, 0.25)))),
          scale: scale * (1 - i / nodeCount),
          direction: direction,
          hasFruit: random.nextChance(fruitProbability(i, direction + tilt)),
        ),
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

  /// Removes all branches or nodes smaller than minScale.
  PlantBranch prune(double minScale) => PlantBranch(
        origin,
        scale,
        nodes
            .where((node) => node.scale > minScale)
            .map((node) => node.prune(minScale)),
      );
}

@immutable
class PlantNode {
  PlantNode(this.position, this.scale, Iterable<PlantBranch> branches)
      : _branches = branches.toBuiltList();

  factory PlantNode._generate(
    Random random, {
    double scale,
    Offset position,
    double direction,
    bool hasFruit = false,
  }) {
    // Probability multiplier for branch
    final branchProb = pow(((0.8 - scale) / 0.8).clamp(0, 1), 0.2);
    final branches = <PlantBranch>[
      if (random.nextChance(0.5 * branchProb))
        PlantBranch._generate(
          random,
          origin: position,
          scale: scale * random.nextInRange(0.7, 0.8),
          direction:
              direction + pi * random.nextInRange(0.3, 0.4) * random.nextSign(),
        ),
      if (hasFruit) PlantBranch(position, 0, []),
    ];
    // Create node
    return PlantNode(position, scale, branches);
  }

  final Offset position;
  final double scale;
  final BuiltList<PlantBranch> _branches;
  Iterable<PlantBranch> get branches => _branches;

  @override
  String toString() =>
      '($scale, (${position.dx}, ${position.dy}), branches: $branches)';

  /// Removes all branches or nodes smaller than minScale.
  PlantNode prune(double minScale) => PlantNode(
        position,
        scale,
        branches
            .where((branch) => branch.scale > minScale)
            .map((branch) => branch.prune(minScale)),
      );
}
