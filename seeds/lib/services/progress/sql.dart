import 'package:sqflite/sqflite.dart';

import '../custom_database/sql.dart';
import 'database.dart';
import 'record.dart';

class SqlProgressDatabase extends ProgressDatabase<Database>
    with CustomSqlDatabase<String, ProgressRecord> {
  @override
  String get databaseFileName => 'progress.db';

  @override
  int get databaseVersion => 0;

  @override
  String get createTableSql => '''CREATE TABLE $table
    (
      ${ProgressRecord.kId} TEXT PRIMARY KEY,
      ${ProgressRecord.kProgress} INTEGER,
      ${ProgressRecord.kReward} INTEGER,
      ${ProgressRecord.kLastUpdate} TEXT
    )''';

  @override
  List<String> get upgradeTableSql => [];

  @override
  String get table => 'progress';

  @override
  String get keyColumn => ProgressRecord.kId;

  @override
  Iterable<String> get valueColumns => const [
    ProgressRecord.kId,
    ProgressRecord.kProgress,
    ProgressRecord.kReward,
    ProgressRecord.kLastUpdate
  ];

  @override
  dynamic keyToArg(String key) => key;

  @override
  Map<String, dynamic> valueToArgs(ProgressRecord value) => value.toMap();

  @override
  String resultToKey(dynamic result) => result as String;

  @override
  ProgressRecord resultToValue(Map<String, dynamic> result) =>
      ProgressRecord.fromMap(result);
}
