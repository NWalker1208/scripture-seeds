import 'package:json_annotation/json_annotation.dart';

import '../scriptures/reference.dart';

part 'topic.g.dart';

@JsonSerializable(createToJson: false)
@_CustomReferenceConverter()
class Topic {
  Topic({
    this.id,
    this.name,
    this.cost = 1,
    Iterable<ScriptureReference> references,
  }) : references = references.toSet();

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  final String id;
  final String name;
  final int cost;
  final Set<ScriptureReference> references;

  int referencesInCommon(Topic other) =>
      references.intersection(other.references).length;
}

class _CustomReferenceConverter
    implements JsonConverter<ScriptureReference, String> {
  const _CustomReferenceConverter();

  @override
  ScriptureReference fromJson(String str) => ScriptureReference.parse(str);

  @override
  String toJson(ScriptureReference reference) => reference.toString();
}
