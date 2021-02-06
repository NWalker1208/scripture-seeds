import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../extensions/string.dart';
import '../../pages/activity.dart';
import '../../services/topics/index.dart';
import '../tutorial/help_info.dart';

class PonderActivity extends StatefulWidget {
  final Topic topic;
  final int minWords;

  const PonderActivity(this.topic, {this.minWords = 8, Key key})
      : super(key: key);

  @override
  _PonderActivityState createState() => _PonderActivityState();
}

class _PonderActivityState extends State<PonderActivity>
    with AutomaticKeepAliveClientMixin {
  final _textController = TextEditingController();

  void _updateCommentary(BuildContext context, String text) {
    var activity = Provider.of<ActivityProvider>(context, listen: false);

    var wordCount = text.wordCount;
    var completed = wordCount >= widget.minWords;
    activity[1] = completed;
    activity.commentary = text;
    updateKeepAlive();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => _textController.value.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HelpInfo(
      tag: 1,
      title: 'Ponder',
      helpText: 'Write down what you learned about ${widget.topic.name} '
          'from the verses you read.',
      child: Center(
        child: ListView(
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 80),
          children: [
            Selector<ActivityProvider, String>(
              selector: (context, activity) => activity.commentary,
              builder: (context, commentary, child) {
                var wordCount = commentary.wordCount;

                return TextField(
                  onChanged: (text) => _updateCommentary(context, text),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: '${widget.topic.name.capitalize()}...',
                    counterText: '$wordCount/${widget.minWords} words',
                    counterStyle: Theme.of(context).textTheme.caption.copyWith(
                        color: (wordCount < widget.minWords)
                            ? Theme.of(context).errorColor
                            : null),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
