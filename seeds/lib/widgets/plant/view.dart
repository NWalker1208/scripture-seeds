import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/progress/provider.dart';
import 'widget.dart';

class PlantView extends StatelessWidget {
  final String name;
  final EdgeInsetsGeometry padding;

  PlantView(
    this.name, {
    this.padding = const EdgeInsets.all(20),
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Hero(
        tag: 'plant_view_$name',
        child: Consumer<ProgressProvider>(
          builder: (_, progress, __) {
            final record = progress.getProgressRecord(name);
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(end: record.progressPercent),
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOutCubic,
              builder: (context, progress, child) => PlantWidget(
                growth: progress,
                wilted: record.progressLost != null,
                hasFruit: record.rewardAvailable,
                padding: padding,
              ),
            );
          },
        ),
      );
}
