import 'package:seeds/services/utility.dart';

class ProgressRecord {
  static const String kName = 'name';
  static const String kProgress = 'progress';
  static const String kLastUpdate = 'lastUpdate';

  String name;
  int progress;
  DateTime lastUpdate;

  ProgressRecord({this.name, this.progress = 0, this.lastUpdate});

  factory ProgressRecord.fromMap(Map<String, dynamic> data) => ProgressRecord(
    name: data[kName],
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

  bool get canMakeProgressToday => isFutureDay(lastUpdate, DateTime.now());
}
