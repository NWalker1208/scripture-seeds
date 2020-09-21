import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/services/progress_record.dart';

class DailyProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressData>(
      builder: (context, progress, child) {
        List<ProgressRecord> records = progress.records;

        int completed = 0;
        records.forEach((record) {
          if (!record.canMakeProgressToday) completed++;
        });

        return Text('$completed / ${records.length}');
      },
    );
  }
}

