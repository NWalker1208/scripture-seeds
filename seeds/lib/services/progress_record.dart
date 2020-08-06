import 'dart:math';
import 'package:seeds/services/utility.dart';

class ProgressRecord {
  static const String kName = 'name';
  static const String kProgress = 'progress';
  static const String kLastUpdate = 'lastUpdate';
  static const int kMaxInactiveDays = 3;

  String name;

  DateTime _lastUpdate;
  int _lastProgress;
  final int maxProgress;

  ProgressRecord(this.name, {DateTime lastUpdate, int progress = 0, this.maxProgress = 14}) :
        _lastUpdate = lastUpdate,
        _lastProgress = progress;

  ProgressRecord.fromMap(Map<String, dynamic> data, {this.maxProgress = 14}) :
        name = data[kName],
        _lastProgress = data[kProgress],
        _lastUpdate = DateTime.parse(data[kLastUpdate]);

  Map<String, dynamic> toMap() => {
    kName: name,
    kProgress: _lastProgress,
    kLastUpdate: _lastUpdate.toString()
  };

  @override
  String toString() {
    return toMap().toString();
  }

  int get daysSinceLastUpdate => _lastUpdate.daysUntil(DateTime.now());
  bool get canMakeProgressToday => _lastUpdate == null || daysSinceLastUpdate > 0;

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

  // Setting progress automatically updates lastUpdate
  // Leaving progress null automatically increments it
  void updateProgress({int progress}) {
    if (progress == null) {
      progress = this.progress;

      // If progress has been lost (plant wilted), don't increment progress
      if (daysSinceLastUpdate ?? 0 < kMaxInactiveDays)
        progress++;
    }

    _lastProgress = progress;
    _lastUpdate = DateTime.now();
  }
}
