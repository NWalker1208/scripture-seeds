import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/scriptures/books.dart';

import '../services/data/journal.dart';
import '../services/data/progress.dart';
import '../services/scriptures/volumes.dart';
import '../services/study/history.dart';
import '../services/study/provider.dart';
import '../services/topics/index.dart';
import '../services/topics/reference.dart';
import '../services/utility.dart';
import '../widgets/activity/ponder.dart';
import '../widgets/activity/progress.dart';
import '../widgets/activity/share.dart';
import '../widgets/activity/study.dart';
import '../widgets/animated_indexed_stack.dart';
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
  int _stage;
  Reference _reference;
  GlobalKey<HelpInfoState> _helpKey;

  void nextStage(ActivityProvider activity) {
    if (_stage == 2) {
      _endActivity(activity);
    } else {
      setState(() {
        FocusScope.of(context).unfocus();
        _stage++;
      });
    }
  }

  void _endActivity(ActivityProvider activity) {
    if (activity.saveToJournal) {
      Provider.of<JournalData>(context, listen: false)
          .createEntry(activity.createJournalEntry(widget.topic, _reference));
    }

    Provider.of<StudyHistory>(context, listen: false).markAsStudied(_reference);
    Provider.of<ProgressData>(context, listen: false)
        .addProgress(widget.topic.id);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    _stage = 0;
    _helpKey = GlobalKey();

    // Pick a reference to study
    var lib = Provider.of<StudyLibraryProvider>(context, listen: false);
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
            setState(() {
              FocusScope.of(context).unfocus();
              _stage--;
            });
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
              'Share what you studied with others. '
                  'You can also save your notes to your journal.',
            ][_stage],
            key: _helpKey,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Daily Activity'),
                actions: [
                  if (_stage == 0)
                    IconButton(
                      icon: const Icon(Icons.open_in_new),
                      tooltip: 'Open in Gospel Library',
                      onPressed: () => _reference.openInGospelLibrary(),
                    ),
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
                            RaisedButton.icon(
                              icon: Icon(Icons.settings),
                              label: Text('Settings'),
                              textColor: Colors.white,
                              onPressed: () => Navigator.of(context)
                                  .popAndPushNamed('/settings'),
                            )
                          ],
                        ),
                      ),
                    )
                  : AnimatedIndexedStack(
                      duration: const Duration(milliseconds: 200),
                      index: _stage,
                      children: [
                        StudyActivity(_reference),
                        PonderActivity(widget.topic),
                        ShareActivity(widget.topic, _reference),
                      ],
                    ),

              // Floating action button allows user to progress through activity
              floatingActionButton: Consumer<ActivityProvider>(
                builder: (context, activity, _) => TweenAnimationBuilder<Color>(
                  tween: ColorTween(
                      end: activity[_stage]
                          ? (Theme.of(context).accentColor)
                          : Colors.grey[500]),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, color, child) => FloatingActionButton(
                    child: const Icon(Icons.navigate_next),
                    backgroundColor: color,
                    disabledElevation: 1,
                    onPressed:
                        activity[_stage] ? () => nextStage(activity) : null,
                  ),
                ),
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
