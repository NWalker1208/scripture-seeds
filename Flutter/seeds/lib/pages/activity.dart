import 'package:flutter/material.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/widgets/activities/study.dart';
//import 'package:share/share.dart';
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

  @override
  void initState() {
    super.initState();
    activityComplete = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
      ),

      body: StudyActivity(widget.topic, onProgressChange: (completed) => setState(() => activityComplete = completed)),

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: activityComplete ? null : Colors.grey[500],
        disabledElevation: 1,
        onPressed: activityComplete ? () {
          // Share what the user highlighted
          // TODO: Separate this into a different activity
          //Share.share('"${Scripture.quoteBlockHighlight(verses, highlights)}"');

          Provider.of<ProgressData>(context, listen: false).addProgress(widget.topic);
          Navigator.pop(context, true);
        } : null,
      ),

      // Bottom app bar shows progress through the day's activity
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: ActivityProgressMap(activityComplete ? 1 : 0)
      ),
    );
  }
}
