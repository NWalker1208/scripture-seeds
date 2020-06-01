import 'package:flutter/material.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/widgets/activities/study.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';

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

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: activityComplete ? null : Colors.grey[500],
        disabledElevation: 2,
        onPressed: activityComplete ? () {
          // Share what the user highlighted
          // TODO: Separate this into a different activity
          //Share.share('"${Scripture.quoteBlockHighlight(verses, highlights)}"');

          Provider.of<ProgressData>(context, listen: false).updateProgress(widget.topic);
          Navigator.pop(context, true);
        } : null,
      ),
    );
  }
}
