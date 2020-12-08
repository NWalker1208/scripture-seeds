import 'dart:async';

import 'package:flutter/material.dart';

import '../../pages/activity.dart';
import '../../services/library/study_resource.dart';
import '../highlight/span.dart';
import 'activity_widget.dart';

class StudyActivity extends ActivityWidget {
  final StudyResource resource;

  StudyActivity(
    String topic,
    this.resource, {
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
  String getHelpText() =>
      'Study the scripture or quote and highlight the parts that are most important to you.';

  static StudyActivityState of(BuildContext context) =>
      context.findAncestorStateOfType<StudyActivityState>();
}

class StudyActivityState extends State<StudyActivity> {
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
    super.initState();
    highlights = <int, List<WordState>>{};
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => (index.isEven)
                    ? widget.resource.body[index ~/ 2]
                        .toWidget(context, index ~/ 2)
                    : SizedBox(height: 8.0),
                semanticIndexCallback: (widget, localIndex) =>
                    (localIndex.isEven) ? localIndex ~/ 2 : null,
                childCount: widget.resource.body.length * 2 - 1,
              ),
            ),
          ),
          SliverPadding(
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
          ),
        ],
      );
}
