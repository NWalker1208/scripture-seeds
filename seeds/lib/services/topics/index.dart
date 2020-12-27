import 'package:json_annotation/json_annotation.dart';

import 'reference.dart';

part 'index.g.dart';

@JsonSerializable()
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

  Set<String> get topics => _index.keys.toSet();
  Topic operator [](String id) => _index[id];

  Set<String> relatedTo(String topic, {int referencesInCommon = 6}) => {
        for (var other in topics)
          if (other != topic &&
              _index[topic]
                      .references
                      .intersection(_index[other].references)
                      .length >
                  referencesInCommon)
            other
      };
}

@JsonSerializable()
@_CustomReferenceConverter()
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

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}

class _CustomReferenceConverter implements JsonConverter<Reference, String> {
  const _CustomReferenceConverter();

  @override
  Reference fromJson(String str) => Reference.parse(str);

  @override
  String toJson(Reference reference) => reference.toString();
}
