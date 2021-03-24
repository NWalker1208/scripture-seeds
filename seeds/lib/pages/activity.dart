import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../extensions/list.dart';
import '../extensions/string.dart';
import '../services/history/provider.dart';
import '../services/journal/entry.dart';
import '../services/journal/provider.dart';
import '../services/progress/provider.dart';
import '../services/proxies/study_library.dart';
import '../services/scriptures/reference.dart';
import '../services/scriptures/volumes.dart';
import '../services/topics/topic.dart';
import '../widgets/activity/error.dart';
import '../widgets/activity/progress.dart';
import '../widgets/activity/stages.dart';
import '../widgets/animation/fab.dart';
import '../widgets/tutorial/button.dart';

class ActivityPage extends StatefulWidget {
  final Topic topic;

  ActivityPage(this.topic, {Key key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class ActivityProvider extends ChangeNotifier {
  int _stage = 0;
  int _maxStage = 0;
  String _quote = '';
  String _commentary = '';
  bool _saveToJournal = false;

  bool operator [](int stage) => stage < _maxStage;

  void operator []=(int stage, bool completed) {
    if (completed) {
      _maxStage = max(_maxStage, stage + 1);
    } else {
      _maxStage = min(_maxStage, stage);
    }
    notifyListeners();
  }

  int get stage => _stage;

  set stage(int value) {
    if (_stage != value) {
      _stage = value;
      notifyListeners();
    }
  }

  bool get canContinue => this[stage];

  String get quote => _quote;

  set quote(String value) {
    _quote = value;
    notifyListeners();
  }

  String get commentary => _commentary;

  set commentary(String value) {
    _commentary = value;
    notifyListeners();
  }

  bool get saveToJournal => _saveToJournal;

  set saveToJournal(bool value) {
    _saveToJournal = value;
    notifyListeners();
  }

  JournalEntry createJournalEntry(Topic topic, ScriptureReference reference) =>
      JournalEntry(
        category: reference.volume.title,
        quote: quote,
        reference: reference.toString(),
        url: reference.url,
        commentary: commentary,
        tags: [topic.name],
      );
}

class _ActivityPageState extends State<ActivityPage> {
  ScriptureReference _reference;

  /// Advances the activity to the next stage, or ends the activity.
  void nextStage(ActivityProvider activity) {
    if (activity.stage == 2) {
      _endActivity(activity);
    } else {
      activity.stage++;
    }
  }

  void _endActivity(ActivityProvider activity) {
    if (activity.saveToJournal) {
      Provider.of<JournalProvider>(context, listen: false)
          .save(activity.createJournalEntry(widget.topic, _reference));
    }

    Provider.of<HistoryProvider>(context, listen: false)
        .markStudied(_reference);
    Provider.of<ProgressProvider>(context, listen: false)
        .add(widget.topic.id);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    // Pick a reference to study
    var lib = Provider.of<StudyLibraryProxy>(context, listen: false);
    _reference = lib.leastRecent(widget.topic.id).randomItem();
    print('Starting activity for ${widget.topic.name}, studying $_reference');

    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<ActivityProvider>(
        create: (context) => ActivityProvider(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.topic.name.capitalize()),
            actions: [
              Consumer<ActivityProvider>(
                builder: (_, activity, __) =>
                    TutorialButton(tag: 'activity${activity.stage}'),
              ),
            ],
          ),
          body: _reference == null
              ? const ActivityError()
              : ActivityStages(reference: _reference, topic: widget.topic),
          floatingActionButton: Consumer<ActivityProvider>(
            builder: (context, activity, child) => AnimatedFloatingActionButton(
              icon: (activity.stage == 2) ? Icons.check : Icons.navigate_next,
              disabled: activity.stage < 2 && !activity.canContinue,
              onPressed: () => nextStage(activity),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: ActivityProgressMap(),
            ),
          ),
        ),
      );
}
