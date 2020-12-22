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

class StudyActivityState extends State<StudyActivity> {
  List<String> verses;
  Map<int, List<WordState>> highlights;

  void updateHighlight(int id, List<WordState> highlight) {
    highlights[id] = highlight;

    // Determine if the activity has been completed
    var activityCompleted = false;

    var allWords = <WordState>[];
    highlights.forEach((key, value) {
      for (var word in value) {
        if (word.highlighted) activityCompleted = true;
      }
      allWords.addAll(value);
    });

    if (activityCompleted != widget.activityCompleted) {
      widget.onProgressChange?.call(activityCompleted);
    }

    // Update the share text
    var quote = buildSharableQuote(allWords);
    ActivityPage.of(context)?.updateQuote('\u{201C}$quote\u{201D}');
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
        .then((verses) => setState(() => this.verses = verses));

    super.initState();
  }

  @override
  Widget build(BuildContext context) => verses == null
      ? Center(child: CircularProgressIndicator())
      : CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              sliver: SliverToBoxAdapter(
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
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 80.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => (index.isEven)
                      ? HighlightStudyBlock(
                          verses[index ~/ 2],
                          id: index ~/ 2,
                          leadingText: '${index ~/ 2 + 1}. ',
                          key: ValueKey(verses[index ~/ 2]),
                        )
                      : SizedBox(height: 8.0),
                  semanticIndexCallback: (widget, localIndex) =>
                      (localIndex.isEven) ? localIndex ~/ 2 : null,
                  childCount: verses.length * 2 - 1,
                ),
              ),
            ),
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
          ],
        );
}
