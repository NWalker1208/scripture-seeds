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
