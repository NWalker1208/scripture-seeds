import 'dart:async';

import 'package:flutter/material.dart';

import '../../pages/activity.dart';
import '../../services/topics/index.dart';
import '../../services/utility.dart';
import 'activity_widget.dart';

class PonderActivity extends ActivityWidget {
  PonderActivity(
    Topic topic, {
    FutureOr<void> Function(bool) onProgressChange,
    bool completed,
    Key key,
  }) : super(
          topic,
          onProgressChange: onProgressChange,
          activityCompleted: completed,
          key: key,
        );

  @override
  _PonderActivityState createState() => _PonderActivityState();

  @override
  String getHelpText() => 'Write down your thoughts on the previous scripture '
      'and what it teaches you about "${topic.name}."';
}

class _PonderActivityState extends State<PonderActivity> {
  static final int kMinWords = 8;

  int wordCount;

  void updateCount(String text) {
    setState(() {
      wordCount = text.wordCount;
      var completed = wordCount >= kMinWords;
      if (completed != widget.activityCompleted) {
        widget.onProgressChange?.call(completed);
      }

      ActivityPage.of(context).updateCommentary(text);
    });
  }

  @override
  void initState() {
    super.initState();
    wordCount = 0;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Ponder text
            TextField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              maxLines: null,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  /*focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.circular(12),
              ),*/

                  hintText: '${widget.topic.name.capitalize()}...',
                  counterText: '$wordCount/$kMinWords words',
                  counterStyle: DefaultTextStyle.of(context).style.copyWith(
                      color: (wordCount < kMinWords) ? Colors.red : null)),
              onChanged: updateCount,
            )
          ],
        ),
      );
}
