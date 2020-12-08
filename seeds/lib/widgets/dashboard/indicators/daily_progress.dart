import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/custom_icons.dart';
import '../../../services/data/progress.dart';

class DailyProgressIndicator extends StatelessWidget {
  const DailyProgressIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<ProgressData>(
        builder: (context, progress, child) {
          var records = progress.records;

          var completed = 0;
          for (var record in records) {
            if (!record.canMakeProgressToday) completed++;
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$completed / ${records.length}'),
              const SizedBox(width: 4),
              const Icon(CustomIcons.water_drop)
            ],
          );
        },
      );
}
