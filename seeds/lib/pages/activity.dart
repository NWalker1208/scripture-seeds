import 'package:flutter/material.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/services/library/library_history.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/services/library/study_resource.dart';
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
  ActivityPageState createState() => ActivityPageState();

  static ActivityPageState of(BuildContext context) =>
    context.findAncestorStateOfType<ActivityPageState>();
}

class ActivityPageState extends State<ActivityPage> {
  int _stage;
  List<bool> _completed;
  String _quote;
  String _commentary;
  bool _saveToJournal;
  StudyResource _resource;

  void onProgressChange(bool completed) => setState(() => _completed[_stage] = completed);
  void updateQuote(String text) => setState(() => _quote = text);
  void updateCommentary(String text) => setState(() => _commentary = text);
  void updateSaveToJournal(bool save) => setState(() => _saveToJournal = save);

  void _endActivity(JournalEntry journalEntry, BuildContext context) {
    if (_saveToJournal)
      Provider.of<JournalData>(context, listen: false).createEntry(journalEntry);

    Provider.of<LibraryHistory>(context, listen: false).markAsStudied(_resource);
    Provider.of<ProgressData>(context, listen: false).addProgress(widget.topic);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    _stage = 0;
    _completed = new List<bool>.filled(3, false);
    _saveToJournal = false;

    // Load resource
    Library lib = Provider.of<Library>(context, listen: false);
    LibraryHistory history = Provider.of<LibraryHistory>(context, listen: false);
    _resource = lib.leastRecent(history, topic: widget.topic);
  }

  @override
  Widget build(BuildContext context) {

    JournalEntry journalEntry = JournalEntry(
      reference: _quote ?? '',
      commentary: _commentary ?? '',
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
            StudyActivity(widget.topic, _resource, completed: _completed[0], onProgressChange: onProgressChange),
            PonderActivity(widget.topic, completed: _completed[1], onProgressChange: onProgressChange),
            ShareActivity(widget.topic, journalEntry, completed: _completed[2], onProgressChange: onProgressChange)
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
                _endActivity(journalEntry, context);
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
