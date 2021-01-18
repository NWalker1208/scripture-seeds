import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'database.dart';

mixin CustomSqlDatabase<K, V> on CustomDatabase<Database, K, V> {
  /// Filename of the database file.
  String get databaseFileName;

  /// Version number of the database implementation.
  int get databaseVersion;

  /// SQL to execute when creating the database.
  String get createTableSql;

  /// SQL to execute when upgrading the database.
  /// Given the old version is a, and the new version is b:
  /// Items from index a - 1 (inclusive) to b - 1 (exclusive) will be executed.
  List<String> get upgradeTableSql;

  /// Name of the SQL table.
  String get table;

  /// Name of the key column.
  String get keyColumn;

  /// Names of the value columns.
  Iterable<String> get valueColumns;

  /// Convert a key to an SQL-compatible format.
  /// Must return a [int], [num], [String], or [Uint8list].
  dynamic keyToArg(K key);

  /// Convert a database value to an SQL-compatible format.
  /// Must return a map from String to
  /// [int], [num], [String], or [Uint8list].
  Map<String, dynamic> valueToArgs(V value);

  /// Convert an SQL result to a key.
  /// May receive a [int], [num], [String], or [Uint8list].
  K resultToKey(dynamic result);

  /// Convert an SQL result to a database value.
  /// Map values may be an [int], [num], [String], or [Uint8list].
  V resultToValue(Map<String, dynamic> result);

  FutureOr<void> onCreateDatabase(Database db, int version) =>
      db.execute(createTableSql);

  FutureOr<void> onUpgradeDatabase(Database db, int oldVer, int newVer) async {
    for (var sql in upgradeTableSql.sublist(oldVer - 1, newVer - 1)) {
      await db.execute(sql);
    }
    print('Database "$table" upgraded from v$oldVer to v$newVer.');
  }

  @override
  Future<Database> open() async {
    final path = await getDatabasesPath();
    return openDatabase(
      path + databaseFileName,
      version: databaseVersion,
      onCreate: onCreateDatabase,
      onUpgrade: onUpgradeDatabase,
    );
  }

  @override
  Future<Iterable<K>> loadKeys() async {
    final db = await database;
    var entries = await db.query(table, columns: [keyColumn]);
    return [for (var entry in entries) resultToKey(entry[keyColumn])];
  }

  @override
  Future<V> load(K key) async {
    final db = await database;
    var records = await db.query(
      table,
      columns: valueColumns.toList(),
      where: '$keyColumn = ?',
      whereArgs: <dynamic>[keyToArg(key)],
    );

    if (records.isEmpty) return null;
    return resultToValue(records.first);
  }

  @override
  Future<void> save(K key, V value) async {
    final db = await database;
    final entry = valueToArgs(value);
    entry[keyColumn] = keyToArg(key);

    await db.insert(table, entry, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<bool> delete(K key) async {
    final db = await database;
    final count = await db.delete(
      table,
      where: '$keyColumn = ?',
      whereArgs: <dynamic>[keyToArg(key)],
    );
    return count > 0;
  }

  @override
  Future<void> clear() async {
    final db = await database;
    await db.delete(table);
  }

  @override
  Future<void> close() async {
    final db = await database;
    await db.close();
    await super.close();
  }
}
