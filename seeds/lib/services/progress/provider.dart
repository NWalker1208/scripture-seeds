import 'package:flutter/material.dart';

import 'database.dart';
import 'record.dart';

class ProgressProvider extends ChangeNotifier {
  final ProgressDatabase _database;
  Map<String, ProgressRecord> _records;

  ProgressProvider(ProgressDatabase database) : _database = database {
    _database.loadAllRecords().then((records) {
      _records = {
        for (var record in records) record.id: record,
      };
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  // Check if the database has been loaded
  bool get isLoaded => _records != null;

  // Get list of existing records
  Iterable<String> get recordNames => _records?.keys ?? <String>[];
  Iterable<ProgressRecord> get records =>
      _records?.values ?? <ProgressRecord>[];

  // Returns all progress records with topics from the set given.
  Iterable<ProgressRecord> recordsWithTopics(Set<String> topics) =>
      records.where((record) => topics.contains(record.id));

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

    _records[record.id] = record;
    _database.saveRecord(record);
    notifyListeners();

    return true;
  }

  // Increments progress by 1 and sets the date
  bool addProgress(String name, {bool force = false}) {
    if (!isLoaded) return false;

    var record = getProgressRecord(name);

    if (force || record.canMakeProgressToday) {
      record.updateProgress();
      _records[name] = record;
      _database.saveRecord(record);
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
      _database.deleteRecord(name);
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

    final reward = progress.takeReward();
    _database.saveRecord(progress);
    notifyListeners();

    return reward;
  }

  // Deletes all progress entries
  bool resetProgress() {
    if (isLoaded) {
      _records.clear();
      _database.deleteAllRecords();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
