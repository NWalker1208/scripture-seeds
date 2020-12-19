import 'package:json_annotation/json_annotation.dart';

part 'index.g.dart';

@JsonSerializable(checked: true, createToJson: false)
class TopicIndex {
  static const minSchema = 1;
  static const maxSchema = 1;

  final String language;
  final int version;
  final Map<String, Topic> _index;

  TopicIndex({
    this.language = 'eng',
    this.version = 0,
    Iterable<Topic> topics,
  }) : _index = {for (var topic in topics) topic.id: topic};

  factory TopicIndex.fromJson(Map<String, dynamic> json) =>
      _$TopicIndexFromJson(json);

  List<String> get topics => _index.keys.toList();
  Topic operator [](String id) => _index[id];
}

@JsonSerializable(checked: true, createToJson: false)
class Topic {
  final String id;
  final String name;
  final int cost;
  final Set<Reference> references;

  Topic({
    this.id,
    this.name,
    this.cost = 1,
    Iterable<Reference> references,
  }) : references = references.toSet();

  factory Topic.fromJson(Map<String, dynamic> json) =>
      _$TopicFromJson(json);
}

@JsonSerializable(checked: true, createToJson: false)
class Reference {
  final int volume;
  final int book;
  final int chapter;
  final Set<int> verses;

  Reference({
    this.volume,
    this.book,
    this.chapter,
    Iterable<int> verses,
  }) : verses = verses.toSet();

  factory Reference.fromJson(Map<String, dynamic> json) =>
      _$ReferenceFromJson(json);
}
