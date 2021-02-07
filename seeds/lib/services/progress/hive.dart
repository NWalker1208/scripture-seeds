import 'package:hive/hive.dart';
import '../mixins/hive.dart';
import 'database.dart';
import 'record.dart';

class HiveProgressDatabase extends ProgressDatabase<Box<ProgressRecord>>
    with HiveDatabaseMixin<String, ProgressRecord> {
  @override
  String get boxName => 'progress';

  @override
  String keyToString(String key) => key;

  @override
  String stringToKey(String string) => string;
}
