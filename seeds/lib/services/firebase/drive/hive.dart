import 'package:hive/hive.dart';

import '../../mixins/hive.dart';
import 'proxy.dart';

class HiveDriveCacheDatabase extends DriveCacheDatabase<Box<String>>
    with HiveDatabaseMixin<String, String> {
  @override
  String get boxName => 'drive_cache';

  @override
  String keyToString(String key) => key;

  @override
  String stringToKey(String string) => string;
}
