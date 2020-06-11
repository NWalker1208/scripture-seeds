import 'package:flutter/material.dart';

class ActivityProgressMap extends StatelessWidget {
  final int progress;
  final int stages;

  ActivityProgressMap(this.progress, {this.stages = 3, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(stages * 2 - 1, (index) {
        // This math allows the dot and the previous connector to be active for the correct progress
        bool completed = (progress + 1) > (index + 1) / 2;

        if (index % 2 == 0)
          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: completed ? Theme.of(context).accentColor : Colors.grey[500].withAlpha(126)
            ),
          );
        else
          return Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: 4,
              decoration: BoxDecoration(
                  color: completed ? Theme.of(context).accentColor : Colors.grey[500].withAlpha(126)
              ),
            ),
          );
      }),
    );
  }
}
