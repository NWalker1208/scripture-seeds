import 'package:flutter/material.dart';
import 'package:seeds/services/custom_icons.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';
import 'package:seeds/services/social_share_system.dart';

class ShareActivity extends ActivityWidget {
  final List<String> sharableText;

  ShareActivity(String topic, this.sharableText, {void Function(bool, String) onProgressChange, Key key}) :
        super(topic, onProgressChange: onProgressChange, key: key);

  @override
  _ShareActivityState createState() => _ShareActivityState();
}

class _ShareActivityState extends State<ShareActivity> {

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
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Instructions
          Text('Share what you studied today.',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.sharableText[0], style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.5),),
                  Text(widget.sharableText[1], style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.5),)
                ]
              ),
            ),
          ),
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
                  onPressed: null,

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

