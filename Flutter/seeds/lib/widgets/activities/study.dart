import 'package:flutter/material.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';
import 'package:seeds/widgets/highlight_text.dart';
import 'package:seeds/services/library.dart';
import 'package:seeds/services/scripture.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:provider/provider.dart';

class StudyActivity extends ActivityWidget {
  StudyActivity(String topic, {void Function(bool) onProgressChange, Key key}) :
      super(topic, onProgressChange: onProgressChange, key: key);

  @override
  _StudyActivityState createState() => _StudyActivityState();
}

class _StudyActivityState extends State<StudyActivity> {
  List<Scripture> verses;
  List<List<bool>> highlights;
  bool activityComplete;

  void updateHighlight(List<bool> highlight, int verse) {
    setState(() => highlights[verse] = highlight);

    // Determine if the activity is complete
    bool activityCompleteNew = false;
    highlights.forEach((verse) {
      if (verse != null)
        verse.forEach((word) => activityCompleteNew = activityCompleteNew || word);
    });

    if (activityCompleteNew != activityComplete) {
      widget.onProgressChange(activityCompleteNew);
      activityComplete = activityCompleteNew;
    }

    // Print a quote style for debugging
    print(Scripture.quoteBlockHighlight(verses, highlights));
  }

  @override
  void initState() {
    super.initState();

    int currentProgress = Provider.of<ProgressData>(context, listen: false).getProgressRecord(widget.topic).progress;
    int scriptureIndex = currentProgress % Library.topics[widget.topic].length;
    verses = Library.topics[widget.topic][scriptureIndex];

    highlights = List<List<bool>>()..length = verses.length;
    activityComplete = false;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Instructions
              Text('Study the following scripture and highlight the parts that are most important to you.',
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text('Tap a word to highlight it.\nTap and hold to highlight a block of text.',
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              // Chapter title
              Text(
                verses[0].reference(showVerse: false),
                style: Theme.of(context).textTheme.headline4.merge(TextStyle(fontFamily: 'Buenard')),
                textAlign: TextAlign.center,
              ),

              // Map the list of scriptures to a list of highlight text blocks
            ] + verses.asMap().entries.map((MapEntry scripture) {
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: HighlightText(
                  '${scripture.value.verse}. ${scripture.value.text}',
                  disabledWords: 1,

                  // Save highlighted region when changed
                  onChangeHighlight: (List<bool> highlight) =>
                    updateHighlight(highlight.sublist(1), scripture.key),
                ),
              );
            }).toList()
          ),
        ),
      ],
    );
  }
}
