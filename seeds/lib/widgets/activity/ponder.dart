import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/activity.dart';
import '../../services/topics/index.dart';
import '../../services/utility.dart';

class PonderActivity extends StatelessWidget {
  final Topic topic;
  final int minWords;

  const PonderActivity(this.topic, {this.minWords = 8, Key key})
      : super(key: key);

  String getHelpText(Topic topic) =>
      'Write down your thoughts on the previous scripture '
      'and what it teaches you about "${topic.name}."';

  void _updateCommentary(BuildContext context, String text) {
    var activity = Provider.of<ActivityProvider>(context, listen: false);

    var wordCount = text.wordCount;
    var completed = wordCount >= minWords;
    activity[1] = completed;
    activity.commentary = text;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Ponder text
            Selector<ActivityProvider, String>(
              selector: (context, activity) => activity.commentary,
              builder: (context, commentary, child) {
                var wordCount = commentary.wordCount;

                return TextField(
                  onChanged: (text) => _updateCommentary(context, text),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: '${topic.name.capitalize()}...',
                    counterText: '$wordCount/$minWords words',
                    counterStyle: DefaultTextStyle.of(context).style.copyWith(
                        color: (wordCount < minWords) ? Colors.red : null),
                  ),
                );
              },
            )
          ],
        ),
      );
}
