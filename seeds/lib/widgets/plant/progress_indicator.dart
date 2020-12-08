import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../services/data/progress.dart';

class PlantProgressIndicator extends StatefulWidget {
  final String plantName;
  final Color textColor;

  PlantProgressIndicator(
    this.plantName, {
    this.textColor,
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
  Widget build(BuildContext context) => Consumer<ProgressData>(
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
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withAlpha(50)
                  : Colors.green.withAlpha(50),
              progressColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.green,
              linearStrokeCap: LinearStrokeCap.roundAll,
              animation: false,
              leading: Text(
                '${(percent * 100).round()} %',
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(color: widget.textColor),
              ),
              trailing: Icon(Icons.flag, color: widget.textColor),
              percent: percent,
            ),
          );
        },
      );
}
