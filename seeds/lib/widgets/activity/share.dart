import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seeds/pages/activity.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/widgets/activity/activity_widget.dart';
import 'package:seeds/widgets/journal_entry.dart';

class ShareActivity extends ActivityWidget {
  final JournalEntry journalEntry;

  ShareActivity(String topic, this.journalEntry,
      {FutureOr<void> Function(bool) onProgressChange, bool completed, Key key}) :
      super(topic, onProgressChange: onProgressChange, activityCompleted: completed, key: key);

  @override
  _ShareActivityState createState() => _ShareActivityState();

  @override
  String getHelpText() => 'Share what you studied today.';
}

class _ShareActivityState extends State<ShareActivity> {
  bool saveToJournal;

  @override
  void initState() {
    super.initState();
    saveToJournal = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          JournalEntryView(
            widget.journalEntry,
            onShare: () {
              if (!widget.activityCompleted)
                widget.onProgressChange?.call(true);
            }
          ),
          SizedBox(height: 12),

          // Journal
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                value: saveToJournal,
                onChanged: (save) => setState(() {
                  saveToJournal = save;
                  if (!widget.activityCompleted)
                    widget.onProgressChange?.call(true);
                  ActivityPage.of(context)?.updateSaveToJournal(save);
                })
              ),
              Text('Save to journal')
            ],
          ),
        ],
      ),
    );
  }
}

