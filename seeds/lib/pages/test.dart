import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/history/provider.dart';
import 'package:seeds/services/history/sql.dart';
import 'package:seeds/services/journal/entry.dart';
import 'package:seeds/services/journal/json.dart';
import 'package:seeds/services/journal/provider.dart';
import 'package:seeds/services/progress/provider.dart';
import 'package:seeds/services/progress/record.dart';
import 'package:seeds/services/progress/sql.dart';
import 'package:seeds/services/scriptures/reference.dart';

/// Debug-only test page for testing new features.
class TestPage extends StatelessWidget {
  const TestPage({Key key}) : super(key: key);

  void createOldData(BuildContext context) async {
    final progress = SqlProgressDatabase();
    final journal = JsonJournalDatabase();
    final history = SqlHistoryDatabase();

    await progress.saveRecord(ProgressRecord(
      'test',
      progress: 3,
      rewardAvailable: true,
    ));
    await journal.saveEntry(JournalEntry(
      quote: 'quote',
      reference: '1 Nephi 1:1',
      commentary: 'commentary',
    ));
    await history.save(ScriptureReference.parse('1 Nephi 1:1'), DateTime.now());

    await progress.close();
    await journal.close();
    await history.close();
  }

  void upgradeOldData(BuildContext context) async {
    final progress = Provider.of<ProgressProvider>(context, listen: false);
    final journal = Provider.of<JournalProvider>(context, listen: false);
    final history = Provider.of<HistoryProvider>(context, listen: false);

    await progress.modify((data) => SqlProgressDatabase().upgrade(data));
    await journal.modify((data) => JsonJournalDatabase().upgrade(data));
    await history.modify((data) => SqlHistoryDatabase().upgrade(data));

    print(progress.records);
    print(journal.entries);
    print(history.references);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Test Page')),
        body: ListView(
          children: [
            ListTile(
              title: Text('Create Old Data'),
              onTap: () => createOldData(context),
            ),
            ListTile(
              title: Text('Upgrade Old Data'),
              onTap: () => upgradeOldData(context),
            )
          ],
        ),
      );
}
