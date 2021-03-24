import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../extensions/date_time.dart';

part 'record.g.dart';

const int _maxInactiveDays = 3;
const int _maxProgress = 4;

@immutable
@JsonSerializable()
@HiveType(typeId: 0)
class ProgressRecord implements Comparable<ProgressRecord> {
  const ProgressRecord(this.topic, {this.lastUpdate, this.lastProgress = 0});

  /// The topic of this record.
  @HiveField(0)
  final String topic;

  /// The date and time of the last update to this record.
  @HiveField(1)
  final DateTime lastUpdate;

  /// The last progress value given to this record. Progress may have been
  /// lost since then.
  @HiveField(2)
  final int lastProgress;

  /// True if the user can make progress on this topic today.
  bool get ready => lastUpdate == null || lastUpdate.daysAgo > 0;

  /// True if there is a reward ready for this topic.
  bool get hasReward => progress == _maxProgress;

  /// The amount of progress lost from inactivity, if any.
  /// Null if no progress has been lost.
  /// Zero if progress is about to be lost.
  int get progressLost {
    if (lastUpdate == null || lastProgress == 0) return null;
    final lost = lastUpdate.daysAgo - _maxInactiveDays;
    if (lost < 0) return null;
    return min(lost, lastProgress);
  }

  /// The amount of progress made on the topic.
  /// Accounts for progress lost due to inactivity.
  /// Value will be between 0 and [_maxProgress] (inclusive).
  int get progress =>
      (lastProgress - (progressLost ?? 0)).clamp(0, _maxProgress).toInt();

  /// The percentage of progress made, relative to [_maxProgress].
  double get progressPercent => progress / _maxProgress;

  /// The percentage of progress lost, relative to [_maxProgress].
  /// Unlike [progressLost], this can be 0 instead of null.
  double get lostPercent => (progressLost ?? 0) / _maxProgress;

  factory ProgressRecord.fromJson(Map<String, dynamic> json) =>
      _$ProgressRecordFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressRecordToJson(this);

  @override
  int compareTo(ProgressRecord other) =>
      topic.toLowerCase().compareTo(other.topic.toLowerCase());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProgressRecord &&
              topic == other.topic &&
              lastUpdate == other.lastUpdate &&
              lastProgress == other.lastProgress;

  @override
  int get hashCode => hashValues(topic, lastUpdate, lastProgress);

  @override
  String toString() => toJson().toString();
}
