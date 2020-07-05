import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';
import 'package:seeds/services/social_share_system.dart';
import 'package:seeds/widgets/journal_entry.dart';

class ShareActivity extends ActivityWidget {
  final List<String> sharableText;

  ShareActivity(String topic, this.sharableText, {void Function(bool, String) onProgressChange, Key key}) :
        super(topic, onProgressChange: onProgressChange, key: key);

  @override
  _ShareActivityState createState() => _ShareActivityState();
}

class _ShareActivityState extends State<ShareActivity> {
  bool savedToJournal;

  void shareQuote(SharePlatform platform) async {
    SocialShareSystem.shareScriptureQuote(
      platform,
      quote: widget.sharableText[0],
      commentary: widget.sharableText[1],
      onReturn: (success) {
        if (success)
          widget.onProgressChange(true, '');
      }
    );
  }

  @override
  void initState() {
    super.initState();
    savedToJournal = false;
  }

  @override
  void didUpdateWidget(ShareActivity oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sharableText[0] != widget.sharableText[0] ||
        oldWidget.sharableText[1] != widget.sharableText[1])
      setState(() {
        savedToJournal = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    JournalEntry journalEntry = JournalEntry(
      reference: widget.sharableText[0],
      commentary: widget.sharableText[1],
      tags: [widget.topic]
    );

    return Padding(
      padding: EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Instructions
          Text('Share what you studied today.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),

          JournalEntryView(journalEntry),
          SizedBox(height: 30),

          // Share buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Expanded(
                child: RaisedButton.icon(
                  onPressed: () => shareQuote(SharePlatform.System),

                  icon: Icon(Icons.share),
                  label: Text('Share'),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: RaisedButton.icon(
                  onPressed: savedToJournal ? null : () {
                    Provider.of<JournalData>(context, listen: false).createEntry(journalEntry);
                    widget.onProgressChange(true, '');

                    setState(() {
                      savedToJournal = true;
                    });
                  },

                  icon: Icon(Icons.save_alt),
                  label: Text('Save to Journal'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

