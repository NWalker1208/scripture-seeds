import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/services/progress_record.dart';

class PlantProgressIndicator extends StatefulWidget {
  final String plantName;

  PlantProgressIndicator(this.plantName, {Key key}) : super(key: key);

  @override
  _PlantProgressIndicatorState createState() => _PlantProgressIndicatorState();
}

class _PlantProgressIndicatorState extends State<PlantProgressIndicator> {
  double initialProgress;

  @override
  void initState() {
    ProgressData progressData = Provider.of<ProgressData>(context, listen: false);
    ProgressRecord record = progressData.getProgressRecord(widget.plantName);
    initialProgress = record.progressPercent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressData>(
      builder: (context, progressData, child) {
        ProgressRecord record = progressData.getProgressRecord(widget.plantName);

        return TweenAnimationBuilder(
          tween: Tween<double>(begin: initialProgress, end: record.progressPercent),
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOutCubic,

          builder: (BuildContext context, double percent, Widget child) => LinearPercentIndicator(
            backgroundColor: Colors.green[700].withAlpha(80),
            progressColor: Colors.green,
            linearStrokeCap: LinearStrokeCap.roundAll,
            animation: false,

            leading: Text('${(percent * 100).round()} %'),
            trailing: Icon(Icons.flag),

            percent: percent,
          ),
        );
      }
    );
  }
}
