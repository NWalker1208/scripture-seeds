import 'package:flutter/material.dart';
import 'package:seeds/services/data/progress_record.dart';
import 'package:seeds/services/utility.dart';

class PlantStatus extends StatelessWidget {
  final ProgressRecord progress;

  PlantStatus(this.progress);

  @override
  Widget build(BuildContext context) {
    bool canMakeProgress = progress.canMakeProgressToday;
    bool isWilted = progress.progressLost != null;
    IconData icon;

    if (isWilted)
      icon = Icons.error;
    else if (canMakeProgress)
      icon = Icons.radio_button_unchecked;
    else
      icon = Icons.check_circle;

    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(icon),
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text('${progress.name.capitalize()}'),
          ),
        ),
      ],
    );
  }
}
