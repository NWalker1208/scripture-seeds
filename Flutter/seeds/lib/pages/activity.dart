import 'package:flutter/material.dart';
import 'package:seeds/widgets/highlight_text.dart';
import 'package:seeds/services/library.dart';
import 'package:seeds/services/scripture.dart';
import 'package:seeds/services/database_manager.dart';
import 'package:share/share.dart';

class ActivityPage extends StatefulWidget {
  final String topic;

  ActivityPage(this.topic, {Key key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<Scripture> verses;
  List<List<bool>> highlights;
  bool activityComplete;

  void updateHighlight(List<bool> highlight, int verse) {
    setState(() => highlights[verse] = highlight);

    // Determine if the activity is complete
    bool activityCompleteNew = false;
    highlights.forEach((verse) => verse.forEach((word) =>
      activityCompleteNew = activityCompleteNew || word
    ));

    setState(() {
      activityComplete = activityCompleteNew;
    });

    // Print a quote style for debugging
    print(Scripture.quoteBlockHighlight(verses, highlights));
  }

  @override
  void initState() {
    super.initState();

    int currentProgress = DatabaseManager.getProgressRecord(widget.topic).progress;
    int scriptureIndex = currentProgress % Library.topics[widget.topic].length;
    verses = Library.topics[widget.topic][scriptureIndex];

    highlights = List<List<bool>>()..length = verses.length;
    activityComplete = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
      ),

      body: ListView(
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
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: activityComplete ? null : Colors.grey[500],
        disabledElevation: 2,
        onPressed: activityComplete ? () {
          // Share what the user highlighted
          // TODO: Separate this into a different activity
          Share.share('"${Scripture.quoteBlockHighlight(verses, highlights)}"');

          if (DatabaseManager.isLoaded) {
            DatabaseManager.updateProgress(widget.topic);
            DatabaseManager.saveData();
            Navigator.pop(context, true);
          }
          else
            print('Unable to save progress!');
        } : null,
      ),
    );
  }
}
