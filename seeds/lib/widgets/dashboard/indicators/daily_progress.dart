import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/custom_icons.dart';
import 'package:seeds/services/data/progress.dart';
import 'package:seeds/services/data/progress_record.dart';

class DailyProgressIndicator extends StatelessWidget {
  const DailyProgressIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressData>(
      builder: (context, progress, child) {
        List<ProgressRecord> records = progress.records;

        int completed = 0;
        records.forEach((record) {
          if (!record.canMakeProgressToday) completed++;
        });

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
}

