import 'package:flutter/material.dart';
import 'package:seeds/services/custom_icons.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';
import 'package:seeds/widgets/activities/study.dart';
import 'package:seeds/widgets/activities/ponder.dart';
import 'package:seeds/widgets/activities/share.dart';
import 'package:provider/provider.dart';
import 'package:seeds/widgets/activity_progress.dart';

class ActivityPage extends StatefulWidget {
  final String topic;

  ActivityPage(this.topic, {Key key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  bool activityComplete;
  int activityStage;
  List<String> activityShareText;

  void onProgressChange(bool completed, String text) {
    setState(() {
      activityComplete = completed;
      activityShareText[activityStage] = text;
    });
  }

  @override
  void initState() {
    super.initState();
    activityComplete = false;
    activityStage = 0;
    activityShareText = new List<String>(3);
  }

  @override
  Widget build(BuildContext context) {
    ActivityWidget activity;

    // Display the current activity
    switch (activityStage) {
      case 0:
        activity = StudyActivity(widget.topic, onProgressChange: onProgressChange);
        break;
      case 1:
        activity = PonderActivity(widget.topic, onProgressChange: onProgressChange);
        break;
      case 2:
        activity = ShareActivity(widget.topic, activityShareText, onProgressChange: onProgressChange);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
      ),

      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: activity
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: activityComplete ? null : Colors.grey[500],
        disabledElevation: 1,
        onPressed: activityComplete ? () {
          if (activityStage == 2) {
            Provider.of<ProgressData>(context, listen: false).addProgress(widget.topic);
            Navigator.pop(context, true);
          } else {
            setState(() {
              activityComplete = false;
              activityStage++;
            });
          }
        } : null,
      ),

      // Bottom app bar shows progress through the day's activity
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: ActivityProgressMap(activityStage)
        )
      ),
    );
  }
}
