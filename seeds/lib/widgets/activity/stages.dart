import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/activity.dart';
import '../../services/scriptures/reference.dart';
import '../../services/topics/topic.dart';
import '../../services/tutorial/provider.dart';
import '../activity/ponder.dart';
import '../activity/share.dart';
import '../activity/study.dart';

/// Manages stages of activities with PageView
class ActivityStages extends StatefulWidget {
  const ActivityStages({
    this.reference,
    this.topic,
    Key key,
  }) : super(key: key);

  final ScriptureReference reference;
  final Topic topic;

  @override
  _ActivityStagesState createState() => _ActivityStagesState();
}

class _ActivityStagesState extends State<ActivityStages> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activity = Provider.of<ActivityProvider>(context);
    Provider.of<TutorialProvider>(context)
        .maybeShow(context, 'activity${activity.stage}');

    // Animate to correct stage if changed
    if (controller.hasClients && activity.stage != controller.page.round()) {
      FocusScope.of(context).unfocus();
      controller.animateToPage(
        activity.stage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if (activity.stage == 0) {
          return true;
        } else {
          activity.stage--;
          return false;
        }
      },
      child: PageView(
        controller: controller,
        onPageChanged: (page) {
          if (activity.stage != page) {
            FocusScope.of(context).unfocus();
            activity.stage = page;
          }
        },
        children: [
          StudyActivity(widget.reference),
          if (activity[0]) PonderActivity(widget.topic),
          if (activity[1]) ShareActivity(widget.topic, widget.reference),
        ],
      ),
    );
  }
}
