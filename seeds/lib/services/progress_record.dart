import 'dart:math';
import 'package:seeds/services/utility.dart';

class ProgressRecord implements Comparable<ProgressRecord> {
  static const String kName = 'name';
  static const String kProgress = 'progress';
  static const String kReward = 'rewardAvailable';
  static const String kLastUpdate = 'lastUpdate';
  static const int kMaxInactiveDays = 3;

  String name;

  DateTime _lastUpdate;
  int _lastProgress;
  bool _rewardAvailable;
  final int maxProgress;

  ProgressRecord(this.name, {DateTime lastUpdate, int progress = 0,
                 bool rewardAvailable = false, this.maxProgress = 3}) :
        _lastUpdate = lastUpdate,
        _lastProgress = progress,
        _rewardAvailable = rewardAvailable;

  ProgressRecord.fromMap(Map<String, dynamic> data, {this.maxProgress = 3}) :
        name = data[kName],
        _lastProgress = data[kProgress] ?? 0,
        _rewardAvailable = (data[kReward] ?? 0) == 1,
        _lastUpdate = DateTime.parse(data[kLastUpdate]);

  Map<String, dynamic> toMap() => {
    kName: name,
    kProgress: _lastProgress,
    kReward: _rewardAvailable ? 1 : 0,
    kLastUpdate: _lastUpdate.toString()
  };

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  int compareTo(ProgressRecord other) {
    int comp = other._priority.compareTo(_priority);

    if (comp == 0)
      comp = name.compareTo(other.name);

    return comp;
  }

  // Getter
  int get _priority => (progressLost ?? 0) + (canMakeProgressToday ? 1 : 0);

  int get daysSinceLastUpdate => _lastUpdate.daysUntil(DateTime.now());
  bool get canMakeProgressToday => _lastUpdate == null || daysSinceLastUpdate > 0;
  bool get rewardAvailable => _rewardAvailable;

  // Returns null if the user will not lose progress. Returns 0 or greater if the
  // user is about to lose progress.
  int get progressLost {
    int lost = daysSinceLastUpdate;

    if (lost == null)
      return null;
    else
      lost -= kMaxInactiveDays;

    if (lost < 0)
      return null;
    else
      return lost;
  }

  // Access progress adjusted for loss and limits
  int get progress {
    int total = _lastProgress - (progressLost ?? 0);
    return max(0, min(maxProgress, total));
  }

  double get progressPercent => progress / maxProgress;

  // Setting progress automatically updates lastUpdate
  // Leaving progress null automatically increments it
  void updateProgress({int progress}) {
    if (progress == null) {
      progress = this.progress + 1;
    }

    if (progress > maxProgress) {
      _lastProgress = maxProgress;
      _rewardAvailable = true;
    } else
      _lastProgress = progress;

    _lastUpdate = DateTime.now();
  }

  void takeReward() {
    _rewardAvailable = false;
  }
}
