import 'package:flutter/material.dart';
import 'package:seeds/services/custom_icons.dart';
import 'package:share/share.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';
import 'package:seeds/services/social_share_image.dart';

class ShareActivity extends ActivityWidget {
  ShareActivity(String topic, {void Function(bool) onProgressChange, Key key}) :
        super(topic, onProgressChange: onProgressChange, key: key);

  @override
  _ShareActivityState createState() => _ShareActivityState();
}

class _ShareActivityState extends State<ShareActivity> {

  void shareQuote(SocialPlatform platform) async {
    SocialShareImage.shareImage('test', platform, onReturn: (success) {
      if (success)
        widget.onProgressChange(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Instructions
          Text('Consider sharing what you studied today.',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),

          // Share buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton.icon(
                onPressed: () {
                  widget.onProgressChange(true);
                  Share.share('Just completed studying ${widget.topic} for today!');
                },

                icon: Icon(Icons.share),
                label: Text('Share'),
              ),

              // FaceBook button
              IconButton(
                  icon: Icon(CustomIcons.facebook),
                  onPressed: () => shareQuote(SocialPlatform.FaceBook)
              ),

              // Instagram button
              IconButton(
                  icon: Icon(CustomIcons.instagram),
                  onPressed: () => shareQuote(SocialPlatform.Instagram)
              ),

              // Twitter button
              IconButton(
                  icon: Icon(CustomIcons.twitter),
                  onPressed: () => shareQuote(SocialPlatform.Twitter)
              )
            ],
          )
        ],
      ),
    );
  }
}

