import 'package:seeds/services/progress_record.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DatabaseManager {
  static const String kDatabaseFile = 'progress.db';
  static const String kProgressTable = 'progress';

  Database db;

  DatabaseManager(this.db);

  bool get isOpen => db.isOpen;

  // Creates the table of progress records
  static Future<void> createProgressTable(Database db, int version) async {
    final String progressSql = '''CREATE TABLE $kProgressTable
    (
      ${ProgressRecord.kName} TEXT PRIMARY KEY,
      ${ProgressRecord.kProgress} INTEGER,
      ${ProgressRecord.kLastUpdate} TEXT
    )''';

    await db.execute(progressSql);
  }

  // Gets the database
  static Future<DatabaseManager> getDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String path = databasePath + kDatabaseFile;

    return DatabaseManager(
      await openDatabase(path, version: 1, onCreate: createProgressTable));
  }

  // Creates a new progress record
  Future<void> createRecord(ProgressRecord record) async {
    await db.insert(kProgressTable, record.toMap());
  }

  // Gets a list of all progress records
  Future<List<ProgressRecord>> getRecords() async {
    List<Map<String, dynamic>> recordMaps = await db.query(
      kProgressTable,
      columns: [
        ProgressRecord.kName,
        ProgressRecord.kProgress,
        ProgressRecord.kLastUpdate
      ]
    );

    List<ProgressRecord> records = recordMaps.map((map) =>
      ProgressRecord.fromMap(map)).toList();
    return records;
  }

  // Gets the progress for a specific item
  Future<ProgressRecord> getProgress(String name) async {
    List<Map<String, dynamic>> results = await db.query(
      kProgressTable,
      columns: [
        ProgressRecord.kName,
        ProgressRecord.kProgress,
        ProgressRecord.kLastUpdate
      ],
      where: 'name = ?',
      whereArgs: [name]
    );

    if (results.length > 0)
      return ProgressRecord.fromMap(results.first);

    return null;
  }

  // Updates the progress for specific item by incrementing by 1 and setting the date
  Future<bool> updateProgress(String name, {bool force = false}) async {
    ProgressRecord progress = await getProgress(name);

    if (progress == null) {
      await createRecord(ProgressRecord(name: name, progress: 1, lastUpdate: DateTime.now()));
      return true;
    }
    else if (force || progress.canMakeProgressToday) {
      progress.progress++;
      progress.lastUpdate = DateTime.now();

      await db.update(
        kProgressTable,
        progress.toMap(),
        where: 'name = ?',
        whereArgs: [name]
      );
      return true;
    }
    return false;
  }

  // Deletes all progress entries
  Future<void> resetProgress() async {
    await db.delete(kProgressTable);
  }

  // Must run this before destroying database manager
  Future<void> close() async {
    await db.close();
  }

  // Deletes the database file
  static Future<bool> deleteDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String path = databasePath + kDatabaseFile;

    File file = File(path);

    if (!file.existsSync())
      return false;

    file.deleteSync();
    return true;
  }
}
