import 'package:hive/hive.dart';

import '../mixins/hive.dart';
import 'database.dart';
import 'entry.dart';

class HiveJournalDatabase extends JournalDatabase<Box<JournalEntry>>
    with HiveDatabaseMixin<String, JournalEntry> {
  @override
  String get boxName => 'journal';

  @override
  String keyToString(String key) => key;

  @override
  String stringToKey(String string) => string;
}
