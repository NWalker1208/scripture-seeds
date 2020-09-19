import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/services/progress_record.dart';
import 'package:seeds/widgets/plant/painter.dart';

class PlantView extends StatefulWidget {
  final String plantName;
  final Widget child;
  final Widget Function(BuildContext, ProgressRecord, Widget) builder;

  PlantView(this.plantName, {this.child, this.builder, Key key}) : super(key: key);

  @override
  _PlantViewState createState() => _PlantViewState();
}

class _PlantViewState extends State<PlantView> {
  double initialProgress;

  static final Color kDayColor = Colors.lightBlue[200];
  static final Color kNightColor = Colors.indigo[900];

  Color _getSkyColor(double light) {
    return Color.lerp(kNightColor, kDayColor, light);
  }

  @override
  void initState() {
    ProgressData progressData = Provider.of<ProgressData>(context, listen: false);
    ProgressRecord record = progressData.getProgressRecord(widget.plantName);
    initialProgress = record.progressPercent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color skyColor;

    if (Theme.of(context).brightness == Brightness.light)
      skyColor = _getSkyColor(1);
    else if (Theme.of(context).brightness == Brightness.dark)
      skyColor = _getSkyColor(0);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color.lerp(skyColor, Colors.white, 0.2), skyColor],
          stops: const [0, 1]
        )
      ),

      child: Consumer<ProgressData>(
        child: widget.child,
        builder: (context, progressData, child) {
          ProgressRecord record = progressData.getProgressRecord(widget.plantName);
          bool wilted = record.progressLost != null;

          return TweenAnimationBuilder(
            tween: Tween<double>(begin: initialProgress, end: record.progressPercent),
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOutCubic,

            child: child,
            builder: (context, progress, child) => CustomPaint(
              child: widget.builder?.call(context, record, child) ?? child,
              painter: PlantPainter(
                growth: progress,
                wilted: wilted,
                fruit: record.rewardAvailable,
              ),
            ),
          );
        }
      ),
    );
  }
}

