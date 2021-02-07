import 'package:json_annotation/json_annotation.dart';

import 'topic.dart';

part 'index.g.dart';

@JsonSerializable(createToJson: false)
class TopicIndex {
  static const minSchema = 1;
  static const maxSchema = 1;

  TopicIndex({
    this.language = 'eng',
    this.version = 0,
    Iterable<Topic> topics,
  }) : _index = {for (var topic in topics) topic.id: topic};

  factory TopicIndex.fromJson(Map<String, dynamic> json) =>
      _$TopicIndexFromJson(json);

  final String language;
  final int version;
  final Map<String, Topic> _index;

  Iterable<String> get topics => _index.keys;
  Topic operator [](String id) => _index[id];

  Iterable<String> relatedTo(String id, {int maxCount}) {
    final topic = _index[id];
    final otherTopics = _index.values.where((t) => t != topic).toList();
    final inCommon = {
      for (var other in otherTopics) other: topic.referencesInCommon(other),
    };
    // Remove topics that share no reference, sort by number in common
    otherTopics.removeWhere((t) => inCommon[t] == 0);
    otherTopics.sort((a, b) => -inCommon[a].compareTo(inCommon[b]));
    // Take only the most related topics, reduce to IDs, and sort by id.
    final related = maxCount == null ? otherTopics : otherTopics.take(maxCount);
    return related.map((t) => t.id).toList()..sort();
  }
}
