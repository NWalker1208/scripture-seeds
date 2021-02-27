import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/history/provider.dart';
import '../services/history/sql.dart';
import '../services/journal/entry.dart';
import '../services/journal/json.dart';
import '../services/journal/provider.dart';
import '../services/notifications/service.dart';
import '../services/progress/provider.dart';
import '../services/progress/record.dart';
import '../services/progress/sql.dart';
import '../services/scriptures/reference.dart';
import '../widgets/animation/appear_transition.dart';
import '../widgets/animation/list.dart';

/// Debug-only test page for testing new features.
class TestPage extends StatefulWidget {
  const TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<DateTime> items = [];

  void addItem() {
    setState(() {
      items.add(DateTime.now());
    });
  }

  void removeItem(DateTime item) {
    setState(() {
      items.remove(item);
    });
  }

  @override
  void initState() {
    addItem();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Test Page')),
        body: ListView(
          children: [
            ListTile(
              title: Text('Notification'),
              onTap: () => showNotification(context),
            ),
            ListTile(
              title: Text('Create Old Data'),
              onTap: () => createOldData(context),
            ),
            ListTile(
              title: Text('Upgrade Old Data'),
              onTap: () => upgradeOldData(context),
            ),
            ListTile(
              title: Text('Read New Data'),
              onTap: () => readNewData(context),
            ),
            AnimatedListBuilder<DateTime>.list(
              items: items,
              duration: const Duration(seconds: 1),
              insertDelay: const Duration(milliseconds: 250),
              removeDelay: const Duration(milliseconds: 250),
              viewBuilder: (context, children) => Column(
                children: children,
              ),
              itemBuilder: (context, item, animation) => AppearTransition(
                visibility: animation,
                child: ListTile(
                  title: Text('$item'),
                  onTap: addItem,
                  onLongPress: () => removeItem(item),
                ),
              ),
            )
          ],
        ),
      );
}

// Test Functions

void showNotification(BuildContext context) {
  final notifications =
      Provider.of<NotificationService>(context, listen: false);
  notifications.show(NotificationData(0, 'test', 'body', 'payload'));
}

void createOldData(BuildContext context) async {
  final progress = SqlProgressDatabase();
  final journal = JsonJournalDatabase();
  final history = SqlHistoryDatabase();

  await progress.saveRecord(ProgressRecord(
    'agency',
    progress: 3,
    rewardAvailable: true,
  ));
  await progress.saveRecord(ProgressRecord(
    'apostles',
    progress: 2,
    lastUpdate: DateTime.now().subtract(Duration(days: 7)),
  ));
  for (var i = 0; i < 10; i++) {
    await journal.saveEntry(JournalEntry(
      quote: 'quote #$i',
      reference: '1 Nephi 1:$i',
      commentary: 'commentary #$i',
      tags: ['test'],
    ));
    await Future<void>.delayed(Duration(milliseconds: 200));
  }

  await history.save(
    ScriptureReference.parse('1 Nephi 1:1'),
    DateTime.now(),
  );

  await progress.close();
  await journal.close();
  await history.close();

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Data Created'),
  ));
}

void upgradeOldData(BuildContext context) async {
  final progress = Provider.of<ProgressProvider>(context, listen: false);
  final journal = Provider.of<JournalProvider>(context, listen: false);
  final history = Provider.of<HistoryProvider>(context, listen: false);

  await progress.modify((data) => SqlProgressDatabase().upgrade(data));
  await journal.modify((data) => JsonJournalDatabase().upgrade(data));
  await history.modify((data) => SqlHistoryDatabase().upgrade(data));
}

void readNewData(BuildContext context) {
  final progress = Provider.of<ProgressProvider>(context, listen: false);
  final journal = Provider.of<JournalProvider>(context, listen: false);
  final history = Provider.of<HistoryProvider>(context, listen: false);

  print(progress.records);
  print(journal.entries);
  print(history.references);
}
