// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
