import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/journal/provider.dart';
import '../journal_entry.dart';
import 'indicators/streak.dart';

class JournalDashboard extends StatelessWidget {
  const JournalDashboard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Dashboard item title
          const ListTile(
            title: Text('Journal'),
            trailing: StreakIndicator(),
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: Consumer<JournalData>(builder: (context, journal, child) {
              if (journal.entries.isEmpty) {
                return const Text(
                    'Your most recent journal entry will appear here.');
              }

              return Column(
                children: [
                  Text('Most recent entry',
                      style: Theme.of(context).textTheme.caption),
                  const SizedBox(height: 8),
                  JournalEntryView(journal.entries.last),
                ],
              );
            }),
          ),

          // Plant list
          ListTile(
            title: const Text('View All', textAlign: TextAlign.center),
            onTap: () => Navigator.of(context).pushNamed('/journal'),
          ),
        ],
      );
}
