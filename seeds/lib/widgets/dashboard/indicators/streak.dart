import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/journal_data.dart';

class StreakIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<JournalData>(
      builder: (context, journal, child) => Row(
        children: [
          Text('${journal.entries.length}'),
          SizedBox(width: 4),
          Icon(Icons.book)
        ],
      )
    );
  }
}
