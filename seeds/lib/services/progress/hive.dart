import 'package:hive/hive.dart';

import '../mixins/hive.dart';
import 'database.dart';
import 'event.dart';

class HiveEventDatabase extends ProgressEventDatabase<Box<ProgressEvent>>
    with HiveDatabaseMixin<DateTime, ProgressEvent> {
  @override
  final boxName = 'progress_events';

  @override
  String keyToString(DateTime key) => key.toIso8601String();

  @override
  DateTime stringToKey(String string) => DateTime.parse(string);
}
