import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/journal/provider.dart';

class StreakIndicator extends StatelessWidget {
  const StreakIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<JournalProvider>(
        builder: (context, journal, child) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${journal.entries.length}'),
            const SizedBox(width: 4),
            const Icon(Icons.book)
          ],
        ),
      );
}
