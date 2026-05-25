import 'package:sqflite/sqflite.dart';

import '../mixins/sql.dart';
import '../scriptures/reference.dart';
import 'database.dart';

const String _referenceColumn = 'ref';
const String _lastStudiedColumn = 'last_studied';

class SqlHistoryDatabase extends HistoryDatabase<Database>
    with SqlDatabaseMixin<ScriptureReference, DateTime> {
  @override
  String get databaseFileName => 'lib_history.db';

  @override
  int get databaseVersion => 1;

  @override
  String get createTableSql => '''CREATE TABLE $table
    (
      $_referenceColumn TEXT PRIMARY KEY,
      $_lastStudiedColumn TEXT
    )''';

  @override
  List<String> get upgradeTableSql => [];

  @override
  String get table => 'history';

  @override
  String get keyColumn => _referenceColumn;

  @override
  Iterable<String> get valueColumns => const [_lastStudiedColumn];

  @override
  dynamic keyToArg(ScriptureReference key) => key.toString();

  @override
  Map<String, dynamic> valueToArgs(DateTime value) =>
      <String, dynamic>{_lastStudiedColumn: value.toString()};

  @override
  ScriptureReference resultToKey(dynamic result) =>
      ScriptureReference.parse(result as String);

  @override
  DateTime resultToValue(Map<String, dynamic> result) =>
      DateTime.parse(result[_lastStudiedColumn] as String);
}
