import 'package:flutter/material.dart';
import 'package:seeds/services/library/study_resource.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mutex/mutex.dart';
import 'dart:io';

class LibraryHistory extends ChangeNotifier {
  static const String kDatabaseFile = 'lib_history.db';
  static const String kHistoryTable = 'history';
  static const String kIdName = 'id';
  static const String kLastStudiedName = 'last_studied';

  Map<int, DateTime> _history;

  /// Front-End
  LibraryHistory() {
    _loadData().then((success) {
      if (success)
        notifyListeners();
    });
  }

  // Check if the database has been loaded
  bool get isLoaded => _history != null;

  // Gets the date last studied for a library resource.
  // Returns null if never studied or if history is not loaded.
  DateTime dateLastStudied(StudyResource resource) {
    if (!isLoaded || !_history.containsKey(resource.id))
      return null;

    return _history[resource.id];
  }

  // Updates the history of a library resource to show studied on date
  // (Default is today). Fails silently if history has not finished loading.
  void markAsStudied(StudyResource resource, {DateTime date}) {
    if (!isLoaded)
      return;

    if (date == null)
      date = DateTime.now();

    _history[resource.id] = date;
    _saveData();
    notifyListeners();
  }

  // Deletes all history entries
  bool resetProgress() {
    if (isLoaded) {
      _history.clear();
      _saveData();
      notifyListeners();
      return true;
    } else
      return false;
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
  Future<bool> _loadData() async {
    try {
      print('Loading history database...');
      await _databaseMutex.acquire();
      Database db = await _openDatabase();

      _history = await _queryHistory(db);

      await db.close();
      _databaseMutex.release();
      print('History loaded!');
      return true;
    } on DatabaseException catch (e) {
      print('Database exception while loading: $e');
      return false;
    }
  }

  Future<bool> _saveData() async {
    try {
      print('Saving history...');
      await _databaseMutex.acquire();
      Database db = await _openDatabase();

      await _updateHistory(db, _history);

      await db.close();
      _databaseMutex.release();
      print('History save complete!');
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

    return openDatabase(path, version: 1, onCreate: _createHistoryTable);
  }

  // Creates the table of progress records
  static Future<void> _createHistoryTable(Database db, int version) async {
    final String progressSql = '''CREATE TABLE $kHistoryTable
    (
      $kIdName INTEGER PRIMARY KEY,
      $kLastStudiedName TEXT
    )''';

    await db.execute(progressSql);
  }

  // Gets a list of all study history
  static Future<Map<int, DateTime>> _queryHistory(Database db) async {
    List<Map<String, dynamic>> historyMaps = await db.query(
        kHistoryTable,
        columns: [
          kIdName,
          kLastStudiedName,
        ]
    );

    Map<int, DateTime> history = Map.fromIterable(
      historyMaps,
      key: (e) => e[kIdName],
      value: (e) => DateTime.parse(e[kLastStudiedName])
    );

    return history;
  }

  // Updates the records in the database with the history cached here
  static Future<void> _updateHistory(Database db, Map<int, DateTime> history) async {
    Map<int, DateTime> oldHistory = await _queryHistory(db);

    // Save all actions to a batch
    Batch batch = db.batch();

    // Delete oldHistory that don't exist any more
    oldHistory.forEach((id, lastStudied) {
      if (!history.containsKey(id))
        batch.delete(kHistoryTable, where: '$kIdName = ?', whereArgs: [id]);
    });

    // Update or create records
    history.forEach((id, lastStudied) {
      Map<String, dynamic> sqlEntry = {
        kIdName: id,
        kLastStudiedName: lastStudied.toString()
      };

      if (oldHistory.containsKey(id)) {
        batch.update(
          kHistoryTable,
          sqlEntry,
          where: '$kIdName = ?',
          whereArgs: [id]
        );
      } else {
        batch.insert(kHistoryTable, sqlEntry);
      }
    });

    // Run all actions
    await batch.commit();
  }
}