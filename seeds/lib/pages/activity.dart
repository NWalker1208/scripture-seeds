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
import '../widgets/activity/ponder.dart';
import '../widgets/activity/progress.dart';
import '../widgets/activity/share.dart';
import '../widgets/activity/study.dart';
import '../widgets/animation/fab.dart';
import '../widgets/tutorial/help_button.dart';

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
  Widget build(BuildContext context) {
    // Create body
    var result = _reference == null
        ? const ActivityError()
        : _ActivityStages(reference: _reference, topic: widget.topic);

    // Add scaffold
    result = Scaffold(
      body: result,
      appBar: AppBar(
        title: Text(widget.topic.name.capitalize()),
        actions: [
          Consumer<ActivityProvider>(
            builder: (_, activity, __) => HelpButton(filter: activity.stage),
          ),
        ],
      ),
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
    );

    // Add WillPopScope
    result = Consumer<ActivityProvider>(
      builder: (context, activity, child) => WillPopScope(
        onWillPop: () async {
          if (activity.stage == 0) {
            return true;
          } else {
            setState(() => activity.stage--);
            return false;
          }
        },
        child: child,
      ),
      child: result,
    );

    // Create provider
    return ChangeNotifierProvider<ActivityProvider>(
      create: (context) => ActivityProvider(),
      child: result,
    );
  }
}

// Manages stages of activities with PageView
class _ActivityStages extends StatefulWidget {
  const _ActivityStages({
    this.reference,
    this.topic,
    Key key,
  }) : super(key: key);

  final ScriptureReference reference;
  final Topic topic;

  @override
  _ActivityStagesState createState() => _ActivityStagesState();
}

class _ActivityStagesState extends State<_ActivityStages> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<ActivityProvider>(
        builder: (context, activity, child) {
          if (controller.hasClients &&
              activity.stage != controller.page.round()) {
            FocusScope.of(context).unfocus();
            controller.animateToPage(
              activity.stage,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
          return PageView(
            controller: controller,
            onPageChanged: (page) {
              if (activity.stage != page) {
                FocusScope.of(context).unfocus();
                activity.stage = page;
              }
            },
            children: [
              StudyActivity(widget.reference),
              if (activity[0]) PonderActivity(widget.topic),
              if (activity[1]) ShareActivity(widget.topic, widget.reference),
            ],
          );
        },
      );
}
