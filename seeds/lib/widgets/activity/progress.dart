import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/activity.dart';

class ActivityProgressMap extends StatelessWidget {
  ActivityProgressMap({
    this.stages = 3,
    Key key,
  }) : super(key: key);

  final int stages;

  @override
  Widget build(BuildContext context) => Selector<ActivityProvider, int>(
        selector: (context, activity) => activity.stage,
        builder: (context, stage, _) => Row(
          children: List<Widget>.generate(
            stages * 2 - 1,
            (index) {
              // This math allows the dot and the previous connector
              // to be active for the correct progress
              final completed = (stage + 1) > (index + 1) / 2;

              if (index % 2 == 0) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: completed
                          ? Theme.of(context).accentColor
                          : Theme.of(context).disabledColor),
                );
              } else {
                return Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: 4,
                    decoration: BoxDecoration(
                        color: completed
                            ? Theme.of(context).accentColor
                            : Theme.of(context).disabledColor),
                  ),
                );
              }
            },
          ),
        ),
      );
}
