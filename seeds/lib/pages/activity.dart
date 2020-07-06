import 'package:flutter/material.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';
import 'package:seeds/widgets/activities/study.dart';
import 'package:seeds/widgets/activities/ponder.dart';
import 'package:seeds/widgets/activities/share.dart';
import 'package:provider/provider.dart';
import 'package:seeds/widgets/activity_progress.dart';
import 'package:seeds/widgets/animated_indexed_stack.dart';

class ActivityPage extends StatefulWidget {
  final String topic;

  ActivityPage(this.topic, {Key key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _stage;
  List<bool> _completed;
  List<String> _shareText;
  bool _saveToJournal;

  void onProgressChange(bool completed, String text) {
    setState(() {
      _completed[_stage] = completed;
      _shareText[_stage] = text;
    });
  }

  @override
  void initState() {
    super.initState();
    _stage = 0;
    _completed = new List<bool>.filled(3, false);
    _shareText = new List<String>.filled(3, '');
    _saveToJournal = false;
  }

  @override
  Widget build(BuildContext context) {
    JournalEntry journalEntry = JournalEntry(
      reference: _shareText[0],
      commentary: _shareText[1],
      tags: [widget.topic]
    );

    return WillPopScope(
      onWillPop: () async {
        if (_stage == 0)
          return true;
        else {
          setState(() {
            FocusScope.of(context).unfocus();
            _stage--;
          });
          return false;
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text('Daily Activity'),
        ),

        body: AnimatedIndexedStack(
          duration: Duration(milliseconds: 150),
          index: _stage,
          children: <ActivityWidget>[
            StudyActivity(widget.topic, onProgressChange: onProgressChange),
            PonderActivity(widget.topic, onProgressChange: onProgressChange),
            ShareActivity(widget.topic, journalEntry, onProgressChange: onProgressChange,
              onSaveToJournalChange: (saveToJournal) {
                _saveToJournal = saveToJournal;
              },
            )
          ]
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: TweenAnimationBuilder(
          tween: ColorTween(
              begin: Colors.grey[500],
              end: _completed[_stage] ?
                (Theme.of(context).accentColor) :
                Colors.grey[500]
          ),
          duration: Duration(milliseconds: 150),

          builder: (BuildContext context, Color color, Widget child) => FloatingActionButton(
            child: child,
            backgroundColor: color,
            disabledElevation: 1,

            onPressed: _completed[_stage] ? () {
              if (_stage == 2) {
                if (_saveToJournal)
                  Provider.of<JournalData>(context, listen: false).createEntry(journalEntry);

                Provider.of<ProgressData>(context, listen: false).addProgress(widget.topic);
                Navigator.pop(context, true);
              } else {
                setState(() {
                  FocusScope.of(context).unfocus();
                  _stage++;
                });
              }
            } : null,
          ),
          child: Icon(Icons.check),
        ),

        // Bottom app bar shows progress through the day's activity
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: ActivityProgressMap(_stage)
          )
        ),
      ),
    );
  }
}
