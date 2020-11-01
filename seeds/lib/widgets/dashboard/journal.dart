import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/data/journal.dart';
import 'package:seeds/widgets/dashboard/indicators/streak.dart';
import 'package:seeds/widgets/journal_entry.dart';

class JournalDashboard extends StatelessWidget {
  const JournalDashboard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dashboard item title
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Journal', style: Theme.of(context).textTheme.subtitle1),
              const StreakIndicator()
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Consumer<JournalData>(
            builder: (context, journal, child) {
              if (journal.entries.length == 0)
                return const Text('Your most recent journal entry will appear here.');

              return Column(
                children: [
                  Text('Most recent entry', style: Theme.of(context).textTheme.caption),
                  const SizedBox(height: 8),
                  JournalEntryView(journal.entries.last),
                ],
              );
            }
          ),
        ),

        // Plant list
        FlatButton(
          child: const Text('View All'),
          onPressed: () => Navigator.of(context).pushNamed('/journal'),
        )
      ],
    );
  }
}
