import 'package:seeds/services/progress_record.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mutex/mutex.dart';
import 'dart:io';

class DatabaseManager {
  static const String kDatabaseFile = 'progress.db';
  static const String kProgressTable = 'progress';

  static Map<String, ProgressRecord> _records;

  /// Front-End
  // Check if the database has been loaded
  static bool get isLoaded => _records != null;

  // Creates a progress record
  static void createProgressRecord(ProgressRecord record) {
    _records[record.name] = record;
  }

  // Gets the progress for a specific item
  static ProgressRecord getProgressRecord(String name) {
    if (_records == null)
      return null;

    return _records[name];
  }

  // Updates the progress for specific item by incrementing by 1 and setting the date
  static bool updateProgress(String name, {bool force = false}) {
    ProgressRecord progress = _records[name];

    if (progress == null) {
      createProgressRecord(ProgressRecord(name: name, progress: 1, lastUpdate: DateTime.now()));
      return true;
    }
    else if (force || progress.canMakeProgressToday) {
      progress.progress++;
      progress.lastUpdate = DateTime.now();
      _records[name] = progress;
      return true;
    }
    return false;
  }

  // Deletes all progress entries
  static void resetProgress() {
    _records.clear();
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

  /// SQFLite operations
  static Mutex _databaseMutex = Mutex();

  // Loads in data from the database file.
  // This should only need to be called when the program starts.
  static Future<bool> loadData() async {
    try {
      print('Loading database...');
      await _databaseMutex.acquire();
      Database db = await _openDatabase();

      _records = await _queryRecords(db);

      await db.close();
      _databaseMutex.release();
      print('Database loaded!');
      return true;
    } on DatabaseException catch (e) {
      print('Database exception while loading: $e');
      return false;
    }
  }

  static Future<bool> saveData() async {
    try {
      print('Saving database...');
      await _databaseMutex.acquire();
      Database db = await _openDatabase();

      await _updateRecords(db);

      await db.close();
      _databaseMutex.release();
      print('Database save complete!');
      return true;
    } on DatabaseException catch (e) {
      print('Database exception while saving: $e');
      return false;
    }
  }

  // Opens the database file
  static Future<Database> _openDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String path = databasePath + kDatabaseFile;

    return openDatabase(path, version: 1, onCreate: _createProgressTable);
  }

  // Creates the table of progress records
  static Future<void> _createProgressTable(Database db, int version) async {
    final String progressSql = '''CREATE TABLE $kProgressTable
    (
      ${ProgressRecord.kName} TEXT PRIMARY KEY,
      ${ProgressRecord.kProgress} INTEGER,
      ${ProgressRecord.kLastUpdate} TEXT
    )''';

    await db.execute(progressSql);
  }

  // Gets a list of all progress records
  static Future<Map<String, ProgressRecord>> _queryRecords(Database db) async {
    List<Map<String, dynamic>> recordMaps = await db.query(
      kProgressTable,
      columns: [
        ProgressRecord.kName,
        ProgressRecord.kProgress,
        ProgressRecord.kLastUpdate
      ]
    );

    List<ProgressRecord> recordList = recordMaps.map((map) =>
      ProgressRecord.fromMap(map)).toList();

    Map<String, ProgressRecord> records = Map.fromIterable(
      recordList,
      key: (e) => e.name,
      value: (e) => e,
    );

    return records;
  }

  // Updates the records in the database with the records cached here
  static Future<void> _updateRecords(Database db) async {
    Map<String, ProgressRecord> recordsCopy = Map.from(_records);
    Map<String, ProgressRecord> oldRecords = await _queryRecords(db);

    // Save all actions to a batch
    Batch batch = db.batch();

    // Delete oldRecords that don't exist any more
    oldRecords.forEach((name, progress) {
      if (!recordsCopy.containsKey(name))
        batch.delete(kProgressTable, where: 'name = ?', whereArgs: [name]);
    });

    // Update or create records
    recordsCopy.forEach((name, progress) {
      if (oldRecords.containsKey(name)) {
        batch.update(
          kProgressTable,
          progress.toMap(),
          where: 'name = ?',
          whereArgs: [name]
        );
      } else {
        batch.insert(kProgressTable, progress.toMap());
      }
    });

    // Run all actions
    await batch.commit();
  }
}
