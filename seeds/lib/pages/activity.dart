import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/data/journal.dart';
import '../services/data/progress.dart';
import '../services/library/history.dart';
import '../services/library/manager.dart';
import '../services/library/study_resource.dart';
import '../services/settings/library_filter.dart';
import '../services/utility.dart';
import '../widgets/activity/activity_widget.dart';
import '../widgets/activity/ponder.dart';
import '../widgets/activity/progress.dart';
import '../widgets/activity/share.dart';
import '../widgets/activity/study.dart';
import '../widgets/animated_indexed_stack.dart';
import '../widgets/help_page.dart';

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

  JournalEntry _journalEntry;

  StudyActivity _studyActivity;
  PonderActivity _ponderActivity;
  ShareActivity _shareActivity;

  void onProgressChange(bool completed) =>
      setState(() => _completed[_stage] = completed);
  void updateQuote(String text) => setState(() => _quote = text);
  void updateCommentary(String text) => setState(() => _commentary = text);
  void updateSaveToJournal(bool save) => setState(() => _saveToJournal = save);

  void nextStage() {
    if (_stage == 2) {
      _endActivity(_journalEntry, context);
    } else {
      setState(() {
        FocusScope.of(context).unfocus();
        _stage++;
      });
    }
  }

  void _endActivity(JournalEntry journalEntry, BuildContext context) {
    if (_saveToJournal) {
      Provider.of<JournalData>(context, listen: false)
          .createEntry(journalEntry);
    }

    Provider.of<LibraryHistory>(context, listen: false)
        .markAsStudied(_resource);
    Provider.of<ProgressData>(context, listen: false).addProgress(widget.topic);
    Navigator.pop(context, true);
  }

  void _openReference() async {
    if (await canLaunch(_resource.referenceURL)) {
      await launch(_resource.referenceURL);
    }
  }

  @override
  void initState() {
    super.initState();
    _stage = 0;
    _completed = List<bool>.filled(3, false);
    _saveToJournal = false;

    // Load resource
    var lib = Provider.of<LibraryManager>(context, listen: false).library;
    var filter = Provider.of<LibraryFilter>(context, listen: false);
    var history = Provider.of<LibraryHistory>(context, listen: false);
    _resource = lib
        .leastRecent(history, filter: filter, topic: widget.topic)
        .randomItem();
  }

  @override
  Widget build(BuildContext context) {
    // Error page
    if (_resource == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daily Activity')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'We couldn\'t find anything to study!\nTry enabling more study sources in settings.',
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                RaisedButton.icon(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed('/settings');
                    })
              ],
            ),
          ),
        ),
      );
    }

    // Activity
    _journalEntry = JournalEntry(
        category: _resource.category,
        quote: _quote ?? '',
        reference: _resource.reference ?? '',
        url: _resource.referenceURL ?? '',
        commentary: _commentary ?? '',
        tags: [widget.topic]);

    _studyActivity = StudyActivity(widget.topic, _resource,
        completed: _completed[0], onProgressChange: onProgressChange);
    _ponderActivity = PonderActivity(widget.topic,
        completed: _completed[1], onProgressChange: onProgressChange);
    _shareActivity = ShareActivity(widget.topic, _journalEntry,
        completed: _completed[2], onProgressChange: onProgressChange);

    var activities = <ActivityWidget>[
      _studyActivity,
      _ponderActivity,
      _shareActivity
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_stage == 0) {
          return true;
        } else {
          setState(() {
            FocusScope.of(context).unfocus();
            _stage--;
          });
          return false;
        }
      },
      child: HelpPage(
        activities[_stage].runtimeType.toString().toLowerCase(),
        helpText: activities[_stage].getHelpText(),
        pageBuilder: (context, helpPage, child) => Scaffold(
          appBar: AppBar(
            title: Text('Daily Activity'),
            actions: [
              if (_stage == 0)
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  tooltip: 'Open in Gospel Library',
                  onPressed: _openReference,
                ),
              IconButton(
                icon: const Icon(Icons.help),
                tooltip: 'Help',
                onPressed: () => helpPage.showHelpDialog(),
              )
            ],
          ),

          body: child,

          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: TweenAnimationBuilder<Color>(
            tween: ColorTween(
                begin: Colors.grey[500],
                end: _completed[_stage]
                    ? (Theme.of(context).accentColor)
                    : Colors.grey[500]),
            duration: const Duration(milliseconds: 150),
            builder: (context, color, child) => FloatingActionButton(
              child: child,
              backgroundColor: color,
              disabledElevation: 1,
              onPressed: _completed[_stage] ? nextStage : null,
            ),
            child: const Icon(Icons.check),
          ),

          // Bottom app bar shows progress through the day's activity
          bottomNavigationBar: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: ActivityProgressMap(_stage),
            ),
          ),
        ),

        child: AnimatedIndexedStack(
          duration: Duration(milliseconds: 150),
          index: _stage,
          children: activities,
        ),
      ),
    );
  }
}
