// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicIndex _$TopicIndexFromJson(Map<String, dynamic> json) {
  return $checkedNew('TopicIndex', json, () {
    final val = TopicIndex(
      language: $checkedConvert(json, 'language', (v) => v as String),
      version: $checkedConvert(json, 'version', (v) => v as int),
      topics: $checkedConvert(
          json,
          'topics',
          (v) => (v as List)?.map((e) =>
              e == null ? null : Topic.fromJson(e as Map<String, dynamic>))),
    );
    return val;
  });
}

Topic _$TopicFromJson(Map<String, dynamic> json) {
  return $checkedNew('Topic', json, () {
    final val = Topic(
      id: $checkedConvert(json, 'id', (v) => v as String),
      name: $checkedConvert(json, 'name', (v) => v as String),
      cost: $checkedConvert(json, 'cost', (v) => v as int),
      references: $checkedConvert(
          json,
          'references',
          (v) => (v as List)?.map(
              (e) => const _CustomReferenceConverter().fromJson(e as String))),
    );
    return val;
  });
}
