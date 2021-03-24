import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'event.g.dart';

/// Stores information about progress that was made. Used for calculating the
/// current progress and syncing progress with cloud.
@immutable
@JsonSerializable()
@HiveType(typeId: 2)
class ProgressEvent implements Comparable<ProgressEvent> {
  /// Creates an event for the given topic.
  /// DateTime defaults to [DateTime.now].
  /// If the resulting progress value after this event is less than zero,
  /// the progress record for that topic will be removed.
  ProgressEvent(
    this.topic, {
    DateTime dateTime,
    this.value = 0,
    this.reset = false,
  }) : dateTime = dateTime ?? DateTime.now();

  /// Creates an event that removes the progress record for the given topic.
  ProgressEvent.remove(this.topic, {DateTime dateTime})
      : dateTime = dateTime ?? DateTime.now(),
        value = -1,
        reset = true;

  /// The date and time of when the event occurred.
  @HiveField(0)
  final DateTime dateTime;

  /// The topic for which this progress event applies.
  /// Null if applies to all topics (such as for a reset).
  @HiveField(1)
  final String topic;

  /// The amount of progress made for the topic.
  @HiveField(2)
  final int value;

  /// True if the progress should be reset to the given value.
  @HiveField(3)
  final bool reset;

  factory ProgressEvent.fromJson(Map<String, dynamic> json) =>
      _$ProgressEventFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressEventToJson(this);

  @override
  int compareTo(ProgressEvent other) => dateTime.compareTo(other.dateTime);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressEvent &&
          dateTime == other.dateTime &&
          topic == other.topic &&
          value == other.value &&
          reset == other.reset;

  @override
  int get hashCode => dateTime.hashCode;
}
