import '../provider.dart';
import 'database.dart';
import 'record.dart';

class ProgressProvider extends ServiceProvider<ProgressDatabase> {
  ProgressProvider(ProgressDatabase Function() create) : super(create);

  Map<String, ProgressRecord> _records;

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
    notifyService((data) => data.saveRecord(record));
    return true;
  }

  /// Increments progress by 1 and sets the date.
  /// Returns true if progress could be incremented.
  bool increment(String name, {bool force = false}) {
    if (!isLoaded) return false;
    final record = getRecord(name);

    if (force || record.canMakeProgressToday) {
      record.updateProgress();
      _records[name] = record;
      notifyService((data) => data.saveRecord(record));
      return true;
    } else {
      return false;
    }
  }

  /// Deletes a record from progress data, such as when a plant is harvested.
  bool remove(String name) {
    if (isLoaded && _records.containsKey(name)) {
      _records.remove(name);
      notifyService((data) => data.remove(name));
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
    notifyService((data) => data.saveRecord(progress));
    return reward;
  }

  /// Deletes all progress entries
  void reset() {
    if (!isLoaded) return;
    _records.clear();
    notifyService((data) => data.clear());
  }

  @override
  Future<void> loadData(ProgressDatabase data) async {
    _records = await data.loadAll();
  }
}
