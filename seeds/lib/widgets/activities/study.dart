import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seeds/services/library/library_history.dart';
import 'package:seeds/services/library/study_resource.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';
import 'package:seeds/widgets/highlight/span.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:provider/provider.dart';
import 'package:seeds/widgets/study_resource_display.dart';

class StudyActivity extends ActivityWidget {
  StudyActivity(String topic, {FutureOr<void> Function(bool, String) onProgressChange, Key key}) :
      super(topic, onProgressChange: onProgressChange, key: key);

  @override
  StudyActivityState createState() => StudyActivityState();

  static StudyActivityState of(BuildContext context) =>
    context.findAncestorStateOfType<StudyActivityState>();
}

class StudyActivityState extends State<StudyActivity> {
  StudyResource resource;
  Map<int, List<WordState>> highlights;

  void updateHighlight(int id, List<WordState> highlight) {
    highlights[id] = highlight;

    bool activityCompleted = false;

    highlights.forEach((key, value) =>
      value.forEach((word) {
        if (word.highlighted)
          activityCompleted = true;
      })
    );

    widget.onProgressChange?.call(activityCompleted, resource.reference);
  }

  @override
  void initState() {
    super.initState();
    Library lib = Provider.of<Library>(context, listen: false);
    LibraryHistory history = Provider.of<LibraryHistory>(context, listen: false);
    resource = lib.leastRecent(history, topic: widget.topic);
    highlights = Map<int, List<WordState>>();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 40.0),
          child: Column(
            children: <Widget>[
              // Instructions
              Text('Study the following scripture and highlight the parts that are most important to you.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              StudyResourceDisplay(resource),
            ],
          )
        ),
      ],
    );
  }
}
