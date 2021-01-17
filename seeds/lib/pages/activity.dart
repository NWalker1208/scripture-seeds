import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../extensions/list.dart';
import '../extensions/string.dart';
import '../services/data/journal.dart';
import '../services/progress/provider.dart';
import '../services/scriptures/volumes.dart';
import '../services/study/history.dart';
import '../services/study/provider.dart';
import '../services/topics/index.dart';
import '../services/topics/reference.dart';
import '../widgets/activity/ponder.dart';
import '../widgets/activity/progress.dart';
import '../widgets/activity/share.dart';
import '../widgets/activity/study.dart';
import '../widgets/help_info.dart';

class ActivityPage extends StatefulWidget {
  final Topic topic;

  ActivityPage(this.topic, {Key key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class ActivityProvider extends ChangeNotifier {
  final List<bool> _completed;
  String _quote;
  String _commentary;
  bool _saveToJournal;

  bool operator [](int stage) => _completed[stage];
  void operator []=(int stage, bool completed) {
    _completed[stage] = completed;
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

  JournalEntry createJournalEntry(Topic topic, Reference reference) =>
      JournalEntry(
        category: reference.volume.title,
        quote: quote,
        reference: reference.toString(),
        url: reference.url,
        commentary: commentary,
        tags: [topic.name],
      );

  ActivityProvider()
      : _completed = [false, false, false],
        _quote = '',
        _commentary = '',
        _saveToJournal = false;
}

class _ActivityPageState extends State<ActivityPage> {
  int _stage = 0;
  final _stageController = PageController();
  final _helpKey = GlobalKey<HelpInfoState>();
  Reference _reference;

  void setStage(int stage) {
    setState(() => _stage = stage);
    FocusScope.of(context).unfocus();
    _stageController.animateToPage(
      stage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void nextStage(ActivityProvider activity) {
    if (_stage == 2) {
      _endActivity(activity);
    } else {
      setStage(_stage + 1);
    }
  }

  void _endActivity(ActivityProvider activity) {
    if (activity.saveToJournal) {
      Provider.of<JournalData>(context, listen: false)
          .createEntry(activity.createJournalEntry(widget.topic, _reference));
    }

    Provider.of<StudyHistory>(context, listen: false).markAsStudied(_reference);
    Provider.of<ProgressProvider>(context, listen: false)
        .addProgress(widget.topic.id);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    // Pick a reference to study
    var lib = Provider.of<StudyLibraryProvider>(context, listen: false);
    _reference = lib.leastRecent(widget.topic.id).randomItem();
    print('Starting activity for ${widget.topic.name}, studying $_reference');

    super.initState();
  }

  @override
  void dispose() {
    _stageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (_stage == 0) {
            return true;
          } else {
            setStage(_stage - 1);
            return false;
          }
        },
        child: ChangeNotifierProvider<ActivityProvider>(
          create: (context) => ActivityProvider(),
          child: HelpInfo(
            const <String>[
              'activity_study',
              'activity_ponder',
              'activity_share'
            ][_stage],
            title: const <String>['Study', 'Ponder', 'Share'][_stage],
            helpText: <String>[
              'Study the selected verses and highlight the '
                  'parts that teach you about ${widget.topic.name}.',
              'Write down what you learned about ${widget.topic.name} '
                  'from the verses you read.',
              'Here you can share with others what you learned. If you want to '
                  'keep a record of it, press "Save to journal."',
            ][_stage],
            key: _helpKey,
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.topic.name.capitalize()),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.help),
                    tooltip: 'Help',
                    onPressed: () => _helpKey.currentState.showHelpDialog(),
                  )
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
                  : Consumer<ActivityProvider>(
                      builder: (context, activity, child) => PageView(
                        controller: _stageController,
                        onPageChanged: (stage) {
                          if (_stage != stage) {
                            setState(() => _stage = stage);
                            FocusScope.of(context).unfocus();
                          }
                        },
                        children: [
                          StudyActivity(_reference),
                          if (activity[0]) PonderActivity(widget.topic),
                          if (activity[1])
                            ShareActivity(widget.topic, _reference),
                        ],
                      ),
                    ),

              // Floating action button allows user to progress through activity
              floatingActionButton: Consumer<ActivityProvider>(
                builder: (context, activity, child) {
                  final stageCompleted = _stage == 2 || activity[_stage];
                  final icon = (_stage == 2)
                      ? const Icon(Icons.check, key: ValueKey('done'))
                      : const Icon(Icons.navigate_next, key: ValueKey('next'));

                  return TweenAnimationBuilder<Color>(
                    duration: const Duration(milliseconds: 200),
                    tween: ColorTween(
                      end: stageCompleted
                          ? Theme.of(context).accentColor
                          : Theme.of(context).disabledColor,
                    ),
                    builder: (context, color, child) => FloatingActionButton(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: icon,
                      ),
                      backgroundColor: color,
                      disabledElevation: 2,
                      onPressed:
                          stageCompleted ? () => nextStage(activity) : null,
                    ),
                  );
                },
              ),

              // Bottom app bar shows progress through the day's activity
              bottomNavigationBar: BottomAppBar(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: ActivityProgressMap(_stage),
                ),
              ),
            ),
          ),
        ),
      );
}
