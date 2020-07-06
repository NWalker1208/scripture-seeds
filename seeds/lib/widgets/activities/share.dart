import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';
import 'package:seeds/widgets/journal_entry.dart';

class ShareActivity extends ActivityWidget {
  final JournalEntry journalEntry;
  final FutureOr<void> Function(bool) onSaveToJournalChange;

  ShareActivity(String topic, this.journalEntry,
      {this.onSaveToJournalChange, FutureOr<void> Function(bool, String) onProgressChange, Key key}) :
      super(topic, onProgressChange: onProgressChange, key: key);

  @override
  _ShareActivityState createState() => _ShareActivityState();
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
          // Instructions
          Text('Share what you studied today.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),

          JournalEntryView(
            widget.journalEntry,
            onShare: () => widget.onProgressChange?.call(true, ''),
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
                  widget.onProgressChange?.call(true, '');
                  widget.onSaveToJournalChange?.call(save);
                })
              ),
              Text('Save to Journal')
            ],
          ),
        ],
      ),
    );
  }
}

