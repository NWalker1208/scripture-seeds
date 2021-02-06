import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/activity.dart';
import '../../services/scriptures/reference.dart';
import '../../services/topics/index.dart';
import '../journal_entry.dart';
import '../tutorial/help_info.dart';

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
  Widget build(BuildContext context) => HelpInfo(
        title: 'Share',
        helpText: 'Share what you learned with others. If you want to '
            'keep a record of what you wrote, select '
            '"Save to journal."',
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Consumer<ActivityProvider>(
                builder: (context, activity, child) => JournalEntryView(
                  activity.createJournalEntry(topic, reference),
                  onShare: () => _notifyCompleted(context),
                ),
              ),
              SizedBox(height: 12),

              // Journal
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Selector<ActivityProvider, bool>(
                    selector: (context, activity) => activity.saveToJournal,
                    builder: (context, saveToJournal, child) => Checkbox(
                        value: saveToJournal,
                        onChanged: (save) => _notifyCompleted(context, save)),
                  ),
                  Text('Save to journal'),
                ],
              ),
            ],
          ),
        ),
      );
}
