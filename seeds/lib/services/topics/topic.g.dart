// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Topic',
      json,
      ($checkedConvert) {
        final val = Topic(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          cost: $checkedConvert('cost', (v) => (v as num?)?.toInt() ?? 1),
          references: $checkedConvert(
              'references',
              (v) => (v as List<dynamic>).map((e) =>
                  const _CustomReferenceConverter().fromJson(e as String))),
        );
        return val;
      },
    );
