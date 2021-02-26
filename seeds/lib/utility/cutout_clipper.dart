import 'package:flutter/material.dart';

class CutoutClipper extends CustomClipper<Path> {
  const CutoutClipper(this.cutout);
  
  final Path cutout;

  @override
  Path getClip(Size size) => Path()
        ..addRect(Offset.zero & size)
        ..addPath(cutout, Offset.zero)
        ..fillType = PathFillType.evenOdd;

  @override
  bool shouldReclip(CutoutClipper oldClipper) => cutout != oldClipper.cutout;
}
