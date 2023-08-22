import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/progress/provider.dart';
import '../../../utility/custom_icons.dart';

class DailyProgressIndicator extends StatelessWidget {
  const DailyProgressIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<ProgressProvider>(
        builder: (context, progress, child) {
          var records = progress.records;

          var completed = 0;
          var wilted = 0;
          for (var record in records) {
            if (!record.canMakeProgressToday) completed++;
            if (record.progressLost != null) wilted++;
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (wilted > 0) ...[
                Text('$wilted'),
                const SizedBox(width: 4),
                const Icon(Icons.error),
                const SizedBox(width: 8),
              ],
              Text('$completed / ${records.length}'),
              const SizedBox(width: 4),
              const Icon(CustomIcons.water_drop),
            ],
          );
        },
      );
}
