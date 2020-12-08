import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';
import 'package:sqflite/sqflite.dart';

import 'progress_record.dart';

class ProgressData extends ChangeNotifier {
  static const String kDatabaseFile = 'progress.db';
  static const String kProgressTable = 'progress';

  Map<String, ProgressRecord> _records;

  /// Front-End
  ProgressData() {
    _loadData().then((success) {
      if (success) notifyListeners();
    });
  }

  // Check if the database has been loaded
  bool get isLoaded => _records != null;

  // Get list of existing records
  List<String> get recordNames => _records?.keys?.toList() ?? <String>[];
  List<ProgressRecord> get records =>
      _records?.values?.toList() ?? <ProgressRecord>[];

  // Returns all progress records with topics from the set given.
  List<ProgressRecord> recordsWithTopics(Set<String> topics) =>
      records.toList()..removeWhere((record) => !topics.contains(record.name));

  // Gets the progress for a specific item
  // Returns a record with 0 progress if the record does not exist or if the
  // records have not been loaded.
  ProgressRecord getProgressRecord(String name) {
    if (!isLoaded || !_records.containsKey(name)) return ProgressRecord(name);

    return _records[name];
  }

  // Creates a progress record
  bool createProgressRecord(ProgressRecord record) {
    if (!isLoaded) return false;

    _records[record.name] = record;
    // Save to database and notify listeners
    _saveData();
    notifyListeners();

    return true;
  }

  // Increments progress by 1 and sets the date
  bool addProgress(String name, {bool force = false}) {
    if (!isLoaded) return false;

    var progress = getProgressRecord(name);

    if (force || progress.canMakeProgressToday) {
      progress.updateProgress();
      _records[name] = progress;
      // Save to database and notify listeners
      _saveData();
      notifyListeners();

      return true;
    } else {
      return false;
    }
  }

  // Deletes a record from progress data, such as when a plant is harvested.
  bool removeProgressRecord(String name) {
    if (isLoaded && _records.containsKey(name)) {
      _records.remove(name);
      _saveData();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  // Collects the reward from the given plant if available.
  // Returns the number of seeds granted.
  int collectReward(String name) {
    var progress = getProgressRecord(name);

    if (!progress.rewardAvailable) return 0;

    progress.takeReward();
    _saveData();
    notifyListeners();

    return 2; // TODO: Randomize, kill plant
  }

  // Deletes all progress entries
  bool resetProgress() {
    if (isLoaded) {
      _records.clear();
      _saveData();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  // Deletes the database file
  static Future<bool> deleteDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = databasePath + kDatabaseFile;

    var file = File(path);

    if (!file.existsSync()) return false;

    file.deleteSync();
    return true;
  }

  /// SQFLite operations
  static final Mutex _databaseMutex = Mutex();

  // Loads in data from the database file.
  // This should only need to be called when the program starts.
  Future<bool> _loadData() async {
    try {
      print('Loading database...');
      await _databaseMutex.acquire();
      var db = await _openDatabase();

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

  Future<bool> _saveData() async {
    try {
      print('Saving database...');
      await _databaseMutex.acquire();
      var db = await _openDatabase();

      await _updateRecords(db, _records);

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
    final databasePath = await getDatabasesPath();
    final path = databasePath + kDatabaseFile;

    return openDatabase(path,
        version: 3,
        onCreate: _createProgressTable,
        onUpgrade: _upgradeProgressTable);
  }

  // Creates the table of progress records
  static Future<void> _createProgressTable(Database db, int version) async {
    final progressSql = '''CREATE TABLE $kProgressTable
    (
      ${ProgressRecord.kName} TEXT PRIMARY KEY,
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
        SET ${ProgressRecord.kName} = "Jesus Christ"
        WHERE ${ProgressRecord.kName} = "jesus christ"
      ''';
      await db.execute(upgradeSql);
    }

    print('Database upgraded from version $oldVersion to $newVersion.');
  }

  // Gets a list of all progress records
  static Future<Map<String, ProgressRecord>> _queryRecords(Database db) async {
    var recordMaps = await db.query(kProgressTable, columns: [
      ProgressRecord.kName,
      ProgressRecord.kProgress,
      ProgressRecord.kReward,
      ProgressRecord.kLastUpdate
    ]);

    var recordList =
        recordMaps.map((map) => ProgressRecord.fromMap(map)).toList();

    var records = {for (var e in recordList) e.name: e};

    return records;
  }

  // Updates the records in the database with the records cached here
  static Future<void> _updateRecords(
      Database db, Map<String, ProgressRecord> records) async {
    var oldRecords = await _queryRecords(db);

    // Save all actions to a batch
    var batch = db.batch();

    // Delete oldRecords that don't exist any more
    oldRecords.forEach((name, progress) {
      if (!records.containsKey(name)) {
        batch.delete(kProgressTable,
            where: '${ProgressRecord.kName} = ?', whereArgs: <String>[name]);
      }
    });

    // Update or create records
    records.forEach((name, progress) {
      if (oldRecords.containsKey(name)) {
        batch.update(kProgressTable, progress.toMap(),
            where: '${ProgressRecord.kName} = ?', whereArgs: <String>[name]);
      } else {
        batch.insert(kProgressTable, progress.toMap());
      }
    });

    // Run all actions
    await batch.commit();
  }
}
