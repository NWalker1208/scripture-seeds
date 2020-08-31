import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seeds/pages/activity.dart';
import 'package:seeds/services/library/study_resource.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';
import 'package:seeds/widgets/dialogs/instructions.dart';
import 'package:seeds/widgets/highlight/span.dart';
import 'package:seeds/widgets/study_resource_display.dart';

class StudyActivity extends ActivityWidget {
  final StudyResource resource;

  StudyActivity(String topic, this.resource, {FutureOr<void> Function(bool) onProgressChange, bool completed, Key key}) :
      super(topic, onProgressChange: onProgressChange, activityCompleted: completed, key: key);

  @override
  StudyActivityState createState() => StudyActivityState();

  @override
  Future<bool> openInstructions(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => InstructionsDialog()
    );
  }

  static StudyActivityState of(BuildContext context) =>
    context.findAncestorStateOfType<StudyActivityState>();
}

class StudyActivityState extends State<StudyActivity> {
  Map<int, List<WordState>> highlights;

  void updateHighlight(int id, List<WordState> highlight) {
    highlights[id] = highlight;

    // Determine if the activity has been completed
    bool activityCompleted = false;

    List<WordState> allWords = List<WordState>();
    highlights.forEach((key, value) {
      value.forEach((word) {
        if (word.highlighted)
          activityCompleted = true;
      });
      allWords.addAll(value);
    });

    if (activityCompleted != widget.activityCompleted)
      widget.onProgressChange?.call(activityCompleted);

    // Update the share text
    String quote = buildSharableQuote(allWords);
    ActivityPage.of(context)?.updateQuote('\u{201C}$quote\u{201D}\n- ${widget.resource.reference}');
  }

  @override
  void initState() {
    super.initState();
    highlights = Map<int, List<WordState>>();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 80.0),
          child: Column(
            children: <Widget>[
              // Instructions
              Text('Study the following scripture and highlight the parts that are most important to you.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              StudyResourceDisplay(widget.resource),
            ],
          )
        ),
      ],
    );
  }
}
