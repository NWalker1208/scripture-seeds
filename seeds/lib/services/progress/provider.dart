import 'package:flutter/foundation.dart';

import 'database.dart';
import 'record.dart';

class ProgressProvider extends ChangeNotifier {
  ProgressProvider(ProgressDatabase database) : _database = database {
    _database.loadAll().then((records) {
      _records = records;
      notifyListeners();
    });
  }

  final ProgressDatabase _database;
  Map<String, ProgressRecord> _records;

  /// Check if the database has been loaded.
  bool get isLoaded => _records != null;

  /// Get list of existing records.
  Iterable<String> get names => _records?.keys ?? const [];
  Iterable<ProgressRecord> get records => _records?.values ?? const [];

  /// Gets the progress for a specific topic.
  /// Returns a record with 0 progress if the record does not exist or if the
  /// records have not been loaded.
  ProgressRecord getRecord(String name) {
    if (!isLoaded || !_records.containsKey(name)) return ProgressRecord(name);
    return _records[name];
  }

  /// Returns all progress records with topics from the set given.
  Iterable<ProgressRecord> fromTopics(Iterable<String> topics) {
    if (!isLoaded) return const [];
    return records.where((record) => topics.contains(record.id));
  }

  /// Creates a progress record
  bool create(ProgressRecord record) {
    if (!isLoaded) return false;

    _records[record.id] = record;
    _database.saveRecord(record);
    notifyListeners();

    return true;
  }

  /// Increments progress by 1 and sets the date.
  bool increment(String name, {bool force = false}) {
    if (!isLoaded) return false;

    // Gets or creates record for name.
    final record = getRecord(name);

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

  /// Deletes a record from progress data, such as when a plant is harvested.
  bool remove(String name) {
    if (isLoaded && _records.containsKey(name)) {
      _records.remove(name);
      _database.remove(name);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  /// Collects the reward from the given plant if available.
  /// Returns the number of seeds granted.
  int collectReward(String name) {
    var progress = getRecord(name);

    if (!progress.rewardAvailable) return 0;

    final reward = progress.takeReward();
    _database.saveRecord(progress);
    notifyListeners();

    return reward;
  }

  /// Deletes all progress entries
  bool reset() {
    if (isLoaded) {
      _records.clear();
      _database.clear();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
}
