import 'package:flutter/material.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';
import 'package:seeds/widgets/highlight_text.dart';
import 'package:seeds/services/library.dart';
import 'package:seeds/services/scripture.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:provider/provider.dart';

class StudyActivity extends ActivityWidget {
  StudyActivity(String topic, {void Function(bool, String) onProgressChange, Key key}) :
      super(topic, onProgressChange: onProgressChange, key: key);

  @override
  _StudyActivityState createState() => _StudyActivityState();
}

class _StudyActivityState extends State<StudyActivity> {
  List<Scripture> verses;
  List<List<bool>> highlights;

  void updateHighlight(List<bool> highlight, int verse) {
    setState(() => highlights[verse] = highlight);

    // Determine if the activity is complete
    bool activityComplete = false;
    highlights.forEach((verse) {
      if (verse != null)
        verse.forEach((word) => activityComplete = activityComplete || word);
    });

    // Eliminate verses that aren't highlighted
    List<Scripture> sparseVerses = new List<Scripture>.from(verses, growable: true);
    List<List<bool>> sparseHighlights = new List<List<bool>>.from(highlights, growable: true);

    for(int i = 0; i < sparseVerses.length; i++) {
      bool deleteVerse = true;
      if (sparseHighlights[i] != null)
        sparseHighlights[i].forEach((word) => deleteVerse = !word && deleteVerse);

      if (deleteVerse) {
        sparseVerses.removeAt(i);
        sparseHighlights.removeAt(i);
        i--;
      }
    }

    widget.onProgressChange(
        activityComplete,
        '\u{201C}${Scripture.quoteBlockHighlight(sparseVerses, sparseHighlights)}\u{201D}\n- ${Scripture.blockReference(sparseVerses)}'
    );
  }

  @override
  void initState() {
    super.initState();

    int currentProgress = Provider.of<ProgressData>(context, listen: false).getProgressRecord(widget.topic).progress;
    int scriptureIndex = currentProgress % Library.topics[widget.topic].length;
    verses = Library.topics[widget.topic][scriptureIndex];

    highlights = List<List<bool>>()..length = verses.length;
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
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text('Tap a word to highlight it.\nTap and hold to highlight a block of text.',
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
