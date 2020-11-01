import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/data/journal.dart';

class StreakIndicator extends StatelessWidget {
  const StreakIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalData>(
      builder: (context, journal, child) => Row(
        children: [
          Text('${journal.entries.length}'),
          const SizedBox(width: 4),
          const Icon(Icons.book)
        ],
      )
    );
  }
}
