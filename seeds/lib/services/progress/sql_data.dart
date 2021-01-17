import 'package:sqflite/sqflite.dart';

import 'database.dart';
import 'record.dart';

class SqlProgressDatabase extends ProgressDatabase {
  static const String kDatabaseFile = 'progress.db';
  static const String kProgressTable = 'progress';

  final Future<Database> _database;

  SqlProgressDatabase()
      : _database = getDatabasesPath().then((path) => openDatabase(
            path + kDatabaseFile,
            version: 3,
            onCreate: _createProgressTable,
            onUpgrade: _upgradeProgressTable));

  // Creates the table of progress records
  static Future<void> _createProgressTable(Database db, int version) async {
    final progressSql = '''CREATE TABLE $kProgressTable
    (
      ${ProgressRecord.kId} TEXT PRIMARY KEY,
      ${ProgressRecord.kProgress} INTEGER,
      ${ProgressRecord.kReward} INTEGER,
      ${ProgressRecord.kLastUpdate} TEXT
    )''';

    await db.execute(progressSql);
    print('Created new database.');
  }

  // Upgrades old databases
  static Future<void> _upgradeProgressTable(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      final upgradeSql = '''ALTER TABLE $kProgressTable
        ADD COLUMN ${ProgressRecord.kReward} INTEGER
      ''';
      await db.execute(upgradeSql);
    }
    if (oldVersion < 3) {
      final upgradeSql = '''UPDATE $kProgressTable
        SET ${ProgressRecord.kId} = "Jesus Christ"
        WHERE ${ProgressRecord.kId} = "jesus christ"
      ''';
      await db.execute(upgradeSql);
    }

    print('Database upgraded from version $oldVersion to $newVersion.');
  }

  @override
  Future<Iterable<String>> getRecordNames() async {
    final db = await _database;
    var records = await db.query(kProgressTable, columns: [ProgressRecord.kId]);
    return [
      for (var record in records) record[ProgressRecord.kId] as String,
    ];
  }

  @override
  Future<ProgressRecord> loadRecord(String name) async {
    final db = await _database;
    var records = await db.query(
      kProgressTable,
      columns: [
        ProgressRecord.kId,
        ProgressRecord.kProgress,
        ProgressRecord.kReward,
        ProgressRecord.kLastUpdate
      ],
      where: '${ProgressRecord.kId} = ?',
      whereArgs: <String>[name],
    );
    if (records.isEmpty) return null;
    return ProgressRecord.fromMap(records.first);
  }

  @override
  Future<void> saveRecord(ProgressRecord record) async {
    final db = await _database;
    var existing = await db.query(
      kProgressTable,
      where: '${ProgressRecord.kId} = ?',
      whereArgs: <String>[record.id],
    );
    if (existing.isEmpty) {
      await db.insert(
        kProgressTable,
        record.toMap(),
      );
    } else {
      await db.update(
        kProgressTable,
        record.toMap(),
        where: '${ProgressRecord.kId} = ?',
        whereArgs: <String>[record.id],
      );
    }
  }

  @override
  Future<bool> deleteRecord(String name) async {
    final db = await _database;
    var count = await db.delete(
      kProgressTable,
      where: '${ProgressRecord.kId} = ?',
      whereArgs: <String>[name],
    );

    return count > 0;
  }

  @override
  Future<void> deleteAllRecords() async {
    final db = await _database;
    await db.delete(kProgressTable);
  }

  @override
  Future<void> close() async {
    final db = await _database;
    await db.close();
  }
}
