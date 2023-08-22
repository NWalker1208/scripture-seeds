import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/progress/record.dart';
import '../../services/topics/provider.dart';

class PlantStatus extends StatelessWidget {
  final ProgressRecord progress;

  PlantStatus(this.progress);

  @override
  Widget build(BuildContext context) {
    var canMakeProgress = progress.canMakeProgressToday;
    var isWilted = progress.progressLost != null;
    IconData icon;

    if (isWilted) {
      icon = Icons.error;
    } else if (canMakeProgress) {
      icon = Icons.radio_button_unchecked;
    } else {
      icon = Icons.check_circle;
    }

    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(icon),
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Consumer<TopicIndexProvider>(
                builder: (context, topics, _) =>
                    Text('${topics.index[progress.id].name}')),
          ),
        ),
      ],
    );
  }
}
