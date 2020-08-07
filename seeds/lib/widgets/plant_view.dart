import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/services/progress_record.dart';
import 'package:seeds/widgets/plant_painter.dart';

class PlantView extends StatefulWidget {
  final String plantName;
  final Widget child;

  PlantView(this.plantName, {this.child, Key key}) : super(key: key);

  @override
  _PlantViewState createState() => _PlantViewState();
}

class _PlantViewState extends State<PlantView> {
  double initialProgress;

  @override
  void initState() {
    ProgressData progressData = Provider.of<ProgressData>(context, listen: false);
    ProgressRecord record = progressData.getProgressRecord(widget.plantName);
    initialProgress = record.progress / record.maxProgress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressData>(
      builder: (context, progressData, child) {
        ProgressRecord record = progressData.getProgressRecord(widget.plantName);
        double progress = record.progress / record.maxProgress;
        bool wilted = (record.progressLost != null);
        SkyColorMode colorMode = Theme.of(context).brightness == Brightness.light ?
            SkyColorMode.light : SkyColorMode.dark;

        return ClipRect(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: initialProgress, end: progress),
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOutCubic,
            child: child,
            builder: (context, progress, child) => CustomPaint(
              painter: PlantPainter(growth: progress, wilted: wilted, skyColorMode: colorMode),
              child: child,
            ),
          ),
        );
      },
      child: widget.child
    );
  }
}

