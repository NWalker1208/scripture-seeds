import 'package:hive/hive.dart';

import '../../mixins/hive.dart';
import '../record.dart';
import 'database.dart';

class HiveProgressDatabase extends ProgressDatabase<Box<ProgressRecord>>
    with HiveDatabaseMixin<String, ProgressRecord> {
  @override
  final boxName = 'progress';

  @override
  String keyToString(String key) => key;

  @override
  String stringToKey(String string) => string;
}
