// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicIndex _$TopicIndexFromJson(Map<String, dynamic> json) => $checkedCreate(
      'TopicIndex',
      json,
      ($checkedConvert) {
        final val = TopicIndex(
          language: $checkedConvert('language', (v) => v as String? ?? 'eng'),
          version: $checkedConvert('version', (v) => v as int? ?? 0),
          topics: $checkedConvert(
              'topics',
              (v) => (v as List<dynamic>)
                  .map((e) => Topic.fromJson(e as Map<String, dynamic>))),
        );
        return val;
      },
    );
