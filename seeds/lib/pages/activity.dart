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
import '../services/topics/index.dart';
import '../widgets/activity/ponder.dart';
import '../widgets/activity/progress.dart';
import '../widgets/activity/share.dart';
import '../widgets/activity/study.dart';
import '../widgets/animated_fab.dart';
import '../widgets/tutorial/help_button.dart';

class ActivityPage extends StatefulWidget {
  final Topic topic;

  ActivityPage(this.topic, {Key key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class ActivityProvider extends ChangeNotifier {
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
  final _stagesKey = GlobalKey<_ActivityStagesState>();
  ScriptureReference _reference;
  int _stage = 0;

  void nextStage(ActivityProvider activity) {
    if (_stage == 2) {
      _endActivity(activity);
    } else {
      setState(() => _stage++);
    }
  }

  void _endActivity(ActivityProvider activity) {
    if (activity.saveToJournal) {
      Provider.of<JournalProvider>(context, listen: false)
          .save(activity.createJournalEntry(widget.topic, _reference));
    }

    Provider.of<StudyHistory>(context, listen: false).markStudied(_reference);
    Provider.of<ProgressProvider>(context, listen: false)
        .increment(widget.topic.id);
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
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      if (_stage == 0) {
        return true;
      } else {
        setState(() => _stage--);
            return false;
          }
    },
    child: ChangeNotifierProvider<ActivityProvider>(
      create: (context) => ActivityProvider(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.topic.name.capitalize()),
              actions: [
                if (_reference != null)
                  HelpButton(() => _stagesKey.currentState.stageContext),
              ],
            ),

            body: _reference == null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'We couldn\'t find anything to study!\n'
                            'Try enabling more study sources in settings.',
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          ElevatedButton.icon(
                            icon: Icon(Icons.settings),
                            label: Text('Settings'),
                            onPressed: () => Navigator.of(context)
                                .popAndPushNamed('/settings'),
                          )
                        ],
                      ),
                    ),
                  )
                : _ActivityStages(
                    key: _stagesKey,
                    stage: _stage,
                    onStageChange: (stage) => setState(() => _stage = stage),
                    reference: _reference,
                    topic: widget.topic,
                  ),

            // Floating action button allows user to progress through activity
            floatingActionButton: Consumer<ActivityProvider>(
              builder: (context, activity, child) =>
                  AnimatedFloatingActionButton(
                icon: (_stage == 2) ? Icons.check : Icons.navigate_next,
                disabled: _stage < 2 && !activity[_stage],
                onPressed: () => nextStage(activity),
              ),
            ),

            // Bottom app bar shows progress through the day's activity
            bottomNavigationBar: BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: ActivityProgressMap(_stage),
              ),
            ),
          ),
        ),
      );
}

class _ActivityStages extends StatefulWidget {
  const _ActivityStages({
    this.stage,
    this.onStageChange,
    this.reference,
    this.topic,
    Key key,
  }) : super(key: key);

  final int stage;
  final Function(int) onStageChange;
  final ScriptureReference reference;
  final Topic topic;

  @override
  _ActivityStagesState createState() => _ActivityStagesState();
}

class _ActivityStagesState extends State<_ActivityStages> {
  final controller = PageController();
  final study = GlobalKey();
  final ponder = GlobalKey();
  final share = GlobalKey();

  BuildContext get stageContext =>
      [study, ponder, share][widget.stage].currentContext;

  @override
  void didUpdateWidget(_ActivityStages oldWidget) {
    if (widget.stage != oldWidget.stage &&
        widget.stage != controller.page.round()) {
      FocusScope.of(context).unfocus();
      controller.animateToPage(
        widget.stage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<ActivityProvider>(
        builder: (context, activity, child) => PageView(
          controller: controller,
          onPageChanged: (page) {
            if (widget.stage != page) {
              FocusScope.of(context).unfocus();
              widget.onStageChange(page);
            }
          },
          children: [
            StudyActivity(widget.reference, key: study),
            if (activity[0]) PonderActivity(widget.topic, key: ponder),
            if (activity[1])
              ShareActivity(widget.topic, widget.reference, key: share),
          ],
        ),
      );
}
