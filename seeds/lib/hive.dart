import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/journal/entry.dart';
import 'services/progress/event.dart';
import 'services/progress/record.dart';

Future<void> hiveInitialization() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProgressRecordAdapter());
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(ProgressEventAdapter());
}
