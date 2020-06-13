import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    activityComplete = false;
    activityStage = 0;
  }

  @override
  Widget build(BuildContext context) {
    ActivityWidget activity;

    // Display the current activity
    switch (activityStage) {
      case 0:
        activity = StudyActivity(widget.topic, onProgressChange: (completed) => setState(() => activityComplete = completed));
        break;
      case 1:
        activity = PonderActivity(widget.topic, onProgressChange: (completed) => setState(() => activityComplete = completed));
        break;
      case 2:
        activity = ShareActivity(widget.topic, onProgressChange: (completed) => setState(() => activityComplete = completed));
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

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 90, 15),
          child: ActivityProgressMap(activityStage),
        )
      ),
    );
  }
}
