import 'package:hive/hive.dart';

import '../mixins/hive.dart';
import 'database.dart';
import 'entry.dart';

class HiveJournalDatabase extends JournalDatabase<Box<JournalEntry>>
    with HiveDatabaseMixin<DateTime, JournalEntry> {
  @override
  final boxName = 'journal';

  @override
  String keyToString(DateTime key) => key.toIso8601String();

  @override
  DateTime stringToKey(String string) {
    try {
      return DateTime.parse(string);
    } on FormatException {
      print('Invalid journal entry key: "$string"');
      return null;
    }
  }
}
