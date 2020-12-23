import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';
import 'package:sqflite/sqflite.dart';

import '../topics/reference.dart';

class StudyHistory extends ChangeNotifier {
  static const String _databaseFile = 'lib_history.db';
  static const String _historyTable = 'history';
  static const String _referenceName = 'ref';
  static const String _lastStudiedName = 'last_studied';

  Map<Reference, DateTime> _history;
  List<Reference> get referencesStudied => _history?.keys?.toList();

  /// Front-End
  StudyHistory() {
    _loadData().then((success) {
      if (success) notifyListeners();
    });
  }

  // Check if the database has been loaded
  bool get isLoaded => _history != null;

  // Gets the date last studied for a library resource.
  // Returns null if never studied or if history is not loaded.
  DateTime dateLastStudied(Reference reference) {
    if (!isLoaded || !_history.containsKey(reference)) return null;
    return _history[reference];
  }

  // Updates the history of a library resource to show studied on date
  // (Default is today). Fails silently if history has not finished loading.
  void markAsStudied(Reference reference, {DateTime date}) {
    if (!isLoaded) return;

    _history[reference] = date ?? DateTime.now();
    _saveData();
    notifyListeners();

    print('Marked $reference as studied.');
  }

  // Deletes all history entries
  bool resetHistory() {
    if (isLoaded) {
      _history.clear();
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
    final path = databasePath + _databaseFile;

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
      print('Loading history database...');
      await _databaseMutex.acquire();
      var db = await _openDatabase();

      var history = await _queryHistory(db);

      await db.close();
      _databaseMutex.release();

      _history = history.map(
          (reference, value) => MapEntry(Reference.parse(reference), value));
      print('History loaded with ${_history.length} references.');
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
      var db = await _openDatabase();

      await _updateHistory(
        db,
        _history
            .map((reference, value) => MapEntry(reference.toString(), value)),
      );

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
    final databasePath = await getDatabasesPath();
    final path = databasePath + _databaseFile;

    return openDatabase(path,
        version: 2,
        onCreate: _createHistoryTable,
        onUpgrade: _upgradeHistoryTable);
  }

  // Creates the table of progress records
  static Future<void> _createHistoryTable(Database db, int version) async {
    final progressSql = '''CREATE TABLE $_historyTable
    (
      $_referenceName TEXT PRIMARY KEY,
      $_lastStudiedName TEXT
    )''';

    await db.execute(progressSql);
  }

  // Upgrades old databases
  static Future<void> _upgradeHistoryTable(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Delete old history, not useful anymore
      await db.execute('DROP TABLE $_historyTable');
      await _createHistoryTable(db, newVersion);
    }

    print('Database upgraded from version $oldVersion to $newVersion.');
  }

  // Gets a list of all study history
  static Future<Map<String, DateTime>> _queryHistory(Database db) async {
    var historyMaps = await db.query(_historyTable, columns: [
      _referenceName,
      _lastStudiedName,
    ]);

    var history = {
      for (var e in historyMaps)
        e[_referenceName] as String:
            DateTime.parse(e[_lastStudiedName] as String)
    };

    return history;
  }

  // Updates the records in the database with the history cached here
  static Future<void> _updateHistory(
      Database db, Map<String, DateTime> history) async {
    var oldHistory = await _queryHistory(db);

    // Save all actions to a batch
    var batch = db.batch();

    // Delete oldHistory that don't exist any more
    oldHistory.forEach((reference, lastStudied) {
      if (!history.containsKey(reference)) {
        batch.delete(_historyTable,
            where: '$_referenceName = ?', whereArgs: <String>[reference]);
      }
    });

    // Update or create records
    history.forEach((reference, lastStudied) {
      var sqlEntry = <String, dynamic>{
        _referenceName: reference,
        _lastStudiedName: lastStudied.toString()
      };

      if (oldHistory.containsKey(reference)) {
        batch.update(_historyTable, sqlEntry,
            where: '$_referenceName = ?', whereArgs: <String>[reference]);
      } else {
        batch.insert(_historyTable, sqlEntry);
      }
    });

    // Run all actions
    await batch.commit();
  }
}