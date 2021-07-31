import 'dart:math';

import 'package:hive/hive.dart';

import '../../extensions/date_time.dart';

part 'record.g.dart';

@HiveType(typeId: 0)
class ProgressRecord implements Comparable<ProgressRecord> {
  static const String kId = 'name';
  static const String kProgress = 'progress';
  static const String kReward = 'rewardAvailable';
  static const String kLastUpdate = 'lastUpdate';
  static const int kMaxInactiveDays = 3;

  ProgressRecord(
    this.id, {
    DateTime lastUpdate,
    int progress = 0,
    bool rewardAvailable = false,
    this.maxProgress = 3,
  })  : _lastUpdate = lastUpdate,
        _lastProgress = progress,
        _rewardAvailable = rewardAvailable;

  @HiveField(0)
  final String id;
  final int maxProgress;

  @HiveField(1)
  DateTime _lastUpdate;
  @HiveField(2)
  int _lastProgress;
  @HiveField(3)
  bool _rewardAvailable;

  ProgressRecord.fromMap(Map<String, dynamic> data, {this.maxProgress = 3})
      : id = data[kId] as String,
        _lastProgress = data[kProgress] as int ?? 0,
        _rewardAvailable = (data[kReward] ?? 0) == 1,
        _lastUpdate = data[kLastUpdate] == 'null'
            ? null
            : DateTime.parse(data[kLastUpdate] as String);

  Map<String, dynamic> toMap() => <String, dynamic>{
        kId: id,
        kProgress: _lastProgress,
        kReward: _rewardAvailable ? 1 : 0,
        kLastUpdate: _lastUpdate.toString(),
      };

  @override
  String toString() => toMap().toString();

  @override
  int compareTo(ProgressRecord other) =>
      id.toLowerCase().compareTo(other.id.toLowerCase());

  // Getters
  DateTime get lastUpdate => _lastUpdate;
  int get daysSinceLastUpdate => _lastUpdate.daysUntil(DateTime.now());
  bool get canMakeProgressToday =>
      _lastUpdate == null || daysSinceLastUpdate > 0;
  bool get rewardAvailable => _rewardAvailable;

  // Returns null if the user will not lose progress.
  // Returns 0 or greater if the user is about to lose progress.
  int get progressLost {
    var lost = daysSinceLastUpdate;

    // If no lastUpdate is recorded or progress is 0, no progress has been lost
    if (lost == null || _lastProgress == 0) return null;

    // Subtract the time until progress can be lost
    lost -= kMaxInactiveDays;

    // If progress will not be lost after today, return null
    if (lost < 0) return null;

    // Limit progress lost to the amount of progress made
    return min(lost, _lastProgress);
  }

  // Access progress adjusted for loss and limits
  int get progress {
    var total = _lastProgress - (progressLost ?? 0);
    return max(0, min(maxProgress, total));
  }

  double get progressPercent => progress / maxProgress;
  double get lostPercent => (progressLost ?? 0) / maxProgress;

  // Setting progress automatically updates lastUpdate
  // Leaving progress null automatically increments it
  void updateProgress({int progress}) {
    progress ??= this.progress + 1;

    if (progress > maxProgress) {
      _lastProgress = maxProgress;
      _rewardAvailable = true;
    } else {
      _lastProgress = progress;
    }

    _lastUpdate = DateTime.now();
  }

  int takeReward() {
    _rewardAvailable = false;
    _lastProgress = 0;

    return 2; // TODO: Randomize
  }
}
