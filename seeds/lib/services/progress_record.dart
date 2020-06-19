import 'package:seeds/services/utility.dart';

class ProgressRecord {
  static const String kName = 'name';
  static const String kProgress = 'progress';
  static const String kLastUpdate = 'lastUpdate';
  static const int kMaxInactiveDays = 3;

  String name;
  int progress;
  DateTime lastUpdate;

  ProgressRecord(this.name, {this.progress = 0, this.lastUpdate});

  factory ProgressRecord.fromMap(Map<String, dynamic> data) => ProgressRecord(
    data[kName],
    progress: data[kProgress],
    lastUpdate: DateTime.parse(data[kLastUpdate])
  );

  Map<String, dynamic> toMap() => {
    kName: name,
    kProgress: progress,
    kLastUpdate: lastUpdate.toString()
  };

  @override
  String toString() {
    return toMap().toString();
  }

  int get daysSinceLastUpdate => lastUpdate.daysUntil(DateTime.now());
  bool get canMakeProgressToday => lastUpdate == null || daysSinceLastUpdate > 0;
  int get progressLost {
    int lost = daysSinceLastUpdate;

    if (lost == null)
      return 0;
    else
      lost -= kMaxInactiveDays;

    if (lost < 0)
      lost = 0;

    return lost;
  }

  // Returns the stored progress minus progress lost from inactivity
  int get totalProgress {
    int total = progress - progressLost;

    if (total < 0)
      total = 0;

    return total;
  }
}
