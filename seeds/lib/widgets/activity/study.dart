import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/activity.dart';
import '../../services/scriptures/books.dart';
import '../../services/study/provider.dart';
import '../../services/topics/index.dart';
import '../../services/topics/reference.dart';
import '../highlight/span.dart';
import '../highlight/study_block.dart';
import 'activity_widget.dart';

class StudyActivity extends ActivityWidget {
  final Reference reference;

  StudyActivity(
    Topic topic,
    this.reference, {
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
  StudyActivityState createState() => StudyActivityState();

  @override
  String getHelpText() => 'Study the scripture or quote and highlight '
      'the parts that are most important to you.';

  static StudyActivityState of(BuildContext context) =>
      context.findAncestorStateOfType<StudyActivityState>();
}

class _VerseKey {
  final String text;
  final GlobalKey key;

  _VerseKey(this.text, [GlobalKey key]) : key = key ?? GlobalKey();
}

class StudyActivityState extends State<StudyActivity> {
  List<_VerseKey> _verses;
  Map<int, List<WordState>> highlights;

  void updateHighlight(int id, List<WordState> highlight) {
    highlights[id] = highlight;

    // Determine if the activity has been completed
    var activityCompleted = false;

    var allWords = <WordState>[];
    for (var verse in widget.reference.verses) {
      for (var word in highlights[verse - 1]) {
        if (word.highlighted) activityCompleted = true;
      }
      allWords.addAll(highlights[verse - 1]);
    }

    if (activityCompleted != widget.activityCompleted) {
      widget.onProgressChange?.call(activityCompleted);
    }

    // Update the share text
    var quote = buildSharableQuote(allWords);
    ActivityPage.of(context)?.updateQuote('\u{201C}$quote\u{201D}');
  }

  void scrollToVerse(
    int verse, {
    Duration duration = const Duration(milliseconds: 800),
  }) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => Scrollable.ensureVisible(
              _verses[verse].key.currentContext,
              duration: duration,
              curve: Curves.easeInOut,
            ));
  }

  void switchTopic(String topic) {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/plant', arguments: topic);
  }

  @override
  void initState() {
    highlights = <int, List<WordState>>{};

    Provider.of<StudyLibraryProvider>(context, listen: false)
        .getChapterOfReference(widget.reference)
        .then((verses) => setState(() {
              _verses = verses.map((v) => _VerseKey(v)).toList();
              scrollToVerse(widget.reference.verses.first - 1);
            }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) => _verses == null
      ? Center(child: CircularProgressIndicator())
      : ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '${widget.reference.book.title} '
                '${widget.reference.chapter}',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontFamily: 'Buenard'),
              ),
            ),

            // Chapter Text
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 75.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < _verses.length; i++)
                    Container(
                      key: _verses[i].key,
                      decoration: widget.reference.verses.contains(i + 1)
                          ? BoxDecoration(
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.5),
                                width: 4.0,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            )
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                        child: HighlightStudyBlock(
                          _verses[i].text,
                          id: i,
                          leadingText: '${i + 1}. ',
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
          /*SliverPadding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 80.0),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.resource.topics
                    .map(
                      (topic) => Chip(
                        label: Text(topic),
                        backgroundColor: Colors.transparent,
                        shape: StadiumBorder(
                            side: BorderSide(
                                color:
                                    DefaultTextStyle.of(context).style.color)),
                        //onPressed: () => _switchTopic(topic),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),*/
        );
}
