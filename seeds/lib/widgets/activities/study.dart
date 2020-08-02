import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';
import 'package:seeds/widgets/highlight/span.dart';
import 'package:seeds/services/library/library.dart';
import 'package:seeds/services/scripture.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:provider/provider.dart';

class StudyActivity extends ActivityWidget {
  StudyActivity(String topic, {FutureOr<void> Function(bool, String) onProgressChange, Key key}) :
      super(topic, onProgressChange: onProgressChange, key: key);

  @override
  _StudyActivityState createState() => _StudyActivityState();
}

class _StudyActivityState extends State<StudyActivity> {
  List<Scripture> verses;
  List<List<WordState>> highlights;

  void updateHighlight(Map<int,bool> changes, int verse) {
    setState(() {
      changes.forEach((index, value) => highlights[verse][index].highlighted = value);
    });

    // Determine if the activity is complete
    bool activityComplete = false;
    highlights.forEach((verse) {
      if (verse != null)
        verse.forEach((word) => activityComplete = activityComplete || word.highlighted);
    });

    // Eliminate verses that aren't highlighted
    List<Scripture> sparseVerses = new List<Scripture>.from(verses, growable: true);
    List<List<WordState>> sparseHighlights = new List<List<WordState>>.from(highlights, growable: true);

    for(int i = 0; i < sparseVerses.length; i++) {
      bool deleteVerse = true;
      if (sparseHighlights[i] != null)
        sparseHighlights[i].forEach((word) => deleteVerse = !word.highlighted && deleteVerse);

      if (deleteVerse) {
        sparseVerses.removeAt(i);
        sparseHighlights.removeAt(i);
        i--;
      }
    }

    widget.onProgressChange(
        activityComplete,
        ''//'\u{201C}${Scripture.quoteBlockHighlight(sparseVerses, sparseHighlights)}\u{201D}\n- ${Scripture.blockReference(sparseVerses)}'
    );
  }

  @override
  void initState() {
    super.initState();

    int currentProgress = Provider.of<ProgressData>(context, listen: false).getProgressRecord(widget.topic).progress;
    int scriptureIndex = currentProgress % Library.topics[widget.topic].length;
    verses = Library.topics[widget.topic][scriptureIndex];

    highlights = verses.map((verse) => buildWordList(verse.text)).toList();
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
              SizedBox(height: 30),

              // Chapter title
              Text(
                verses[0].reference(showVerse: false),
                style: Theme.of(context).textTheme.headline4.copyWith(fontFamily: 'Buenard'),
                textAlign: TextAlign.center,
              ),

              // Map the list of scriptures to a list of highlight text blocks
            ] + List<Widget>.generate(verses.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: HighlightTextSpan(
                  highlights[index],
                  leadingText: '${verses[index].verse}. ',

                  style: DefaultTextStyle.of(context).style.copyWith(
                    fontFamily: 'Buenard',
                    fontSize: 20,
                    height: 1.5
                  ),

                  // Save highlighted region when changed
                  onChangeHighlight: (Map<int, bool> changes) =>
                    updateHighlight(changes, index),
                ),
              );
            }).toList()
          ),
        ),
      ],
    );
  }
}
