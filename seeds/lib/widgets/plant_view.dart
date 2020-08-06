import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/services/progress_record.dart';
import 'package:seeds/widgets/plant_painter.dart';

class PlantView extends StatelessWidget {
  final String plantName;
  final Widget child;

  PlantView(this.plantName, {this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressData>(
      builder: (context, progressData, child) {
        ProgressRecord record = progressData.getProgressRecord(plantName);
        num progress = record.progress / record.maxProgress;
        bool wilted = (record.progressLost != null);

        return ClipRect(
          child: CustomPaint(
            painter: PlantPainter(length: progress, wilted: wilted),
            child: child
          ),
        );
      },
      child: child
    );
  }
}

