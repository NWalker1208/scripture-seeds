import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/activity.dart';
import '../../services/scriptures/reference.dart';
import '../../services/topics/topic.dart';
import '../journal_entry.dart';
import '../tutorial/focus.dart';
import '../tutorial/help.dart';

class ShareActivity extends StatelessWidget {
  final Topic topic;
  final ScriptureReference reference;

  const ShareActivity(this.topic, this.reference, {Key key}) : super(key: key);

  void _notifyCompleted(BuildContext context, [bool saveToJournal]) {
    var activity = Provider.of<ActivityProvider>(context, listen: false);
    if (!activity[2]) activity[2] = true;
    if (saveToJournal != null) activity.saveToJournal = saveToJournal;
  }

  @override
  Widget build(BuildContext context) => TutorialHelp(
        'activity2',
        index: 0,
        title: 'Step 3 - Share',
        helpText: 'You can share what you highlighted and wrote with others or '
            'save it to your journal.',
        child: Center(
          child: ListView(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(40.0),
            children: <Widget>[
              Consumer<ActivityProvider>(
                builder: (context, activity, child) => JournalEntryView(
                  activity.createJournalEntry(topic, reference),
                  onShare: () => _notifyCompleted(context),
                ),
              ),
              SizedBox(height: 12),
              TutorialFocus(
                'activity2',
                index: 1,
                overlayLabel: Text('Tap here if you want to save this entry.'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Selector<ActivityProvider, bool>(
                      selector: (context, activity) => activity.saveToJournal,
                      builder: (context, saveToJournal, child) => Checkbox(
                        value: saveToJournal,
                        onChanged: (save) => _notifyCompleted(context, save),
                      ),
                    ),
                    Text('Save to journal'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
