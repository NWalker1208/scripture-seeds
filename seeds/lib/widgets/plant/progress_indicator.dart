import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../services/data/progress.dart';

class PlantProgressIndicator extends StatefulWidget {
  final String plantName;

  PlantProgressIndicator(
    this.plantName, {
    Key key,
  }) : super(key: key);

  @override
  _PlantProgressIndicatorState createState() => _PlantProgressIndicatorState();
}

class _PlantProgressIndicatorState extends State<PlantProgressIndicator> {
  double initialProgress;

  @override
  void initState() {
    var progressData = Provider.of<ProgressData>(context, listen: false);
    var record = progressData.getProgressRecord(widget.plantName);
    initialProgress = record.progressPercent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = theme.colorScheme.onPrimary;
    final backgroundColor = theme.colorScheme.onSurface;

    return Consumer<ProgressData>(
      builder: (context, progressData, child) {
        var record = progressData.getProgressRecord(widget.plantName);

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: initialProgress,
            end: record.progressPercent,
          ),
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOutCubic,
          builder: (context, percent, child) => LinearPercentIndicator(
            backgroundColor: backgroundColor.withAlpha(50),
            progressColor: progressColor,
            linearStrokeCap: LinearStrokeCap.roundAll,
            animation: false,
            leading: Text('${(percent * 100).round()} %'),
            trailing: Icon(Icons.flag),
            percent: percent,
          ),
        );
      },
    );
  }
}
