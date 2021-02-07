import 'package:hive/hive.dart';

import '../mixins/hive.dart';
import '../scriptures/reference.dart';
import 'database.dart';

class HiveHistoryDatabase extends HistoryDatabase<Box<DateTime>>
    with HiveDatabaseMixin<ScriptureReference, DateTime> {
  @override
  String get boxName => 'history';

  @override
  String keyToString(ScriptureReference key) => key.toString();

  @override
  ScriptureReference stringToKey(String str) => ScriptureReference.parse(str);
}
