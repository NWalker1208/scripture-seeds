// @dart=2.9

import 'package:hive_flutter/hive_flutter.dart';

import 'services/journal/entry.dart';
import 'services/progress/record.dart';

Future<void> hiveInitialization() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProgressRecordAdapter());
  Hive.registerAdapter(JournalEntryAdapter());
}
