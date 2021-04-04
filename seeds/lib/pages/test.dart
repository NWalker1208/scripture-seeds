import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers.dart';
import '../services/progress/old/hive.dart';
import '../services/progress/provider.dart';
import '../services/progress/record.dart';
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

void createOldData(BuildContext context) async {
  final progress = HiveProgressDatabase();
  await progress.saveRecord(ProgressRecord('agency'));
  await progress.saveRecord(ProgressRecord(
    'apostles',
    lastProgress: 2,
    lastUpdate: DateTime.now().subtract(Duration(days: 3)),
  ));
  await progress.saveRecord(ProgressRecord(
    'hope',
    lastProgress: 4,
    lastUpdate: DateTime.now(),
  ));
  await progress.close();

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Data Created'),
  ));
}

void upgradeOldData(BuildContext context) async {
  await AppProviders.of(context).attemptUpgrade();
}

void readNewData(BuildContext context) {
  final progress = Provider.of<ProgressProvider>(context, listen: false);
  print(progress.topics.map((t) => progress[t]));
}
