// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) {
  return $checkedNew('JournalEntry', json, () {
    final val = JournalEntry(
      created: $checkedConvert(json, 'created',
          (v) => v == null ? null : DateTime.parse(v as String)),
      category: $checkedConvert(json, 'category', (v) => v as String),
      quote: $checkedConvert(json, 'quote', (v) => v as String),
      reference: $checkedConvert(json, 'reference', (v) => v as String),
      url: $checkedConvert(json, 'url', (v) => v as String),
      commentary: $checkedConvert(json, 'commentary', (v) => v as String),
      tags: $checkedConvert(
          json, 'tags', (v) => (v as List)?.map((e) => e as String)),
    );
    return val;
  });
}

Map<String, dynamic> _$JournalEntryToJson(JournalEntry instance) =>
    <String, dynamic>{
      'created': instance.created?.toIso8601String(),
      'category': instance.category,
      'quote': instance.quote,
      'reference': instance.reference,
      'url': instance.url,
      'commentary': instance.commentary,
      'tags': instance.tags?.toList(),
    };
