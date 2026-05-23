// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 1;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      created: fields[0] as DateTime?,
      category: fields[1] as String,
      quote: fields[2] as String,
      reference: fields[3] as String,
      url: fields[4] as String,
      commentary: fields[5] as String,
      tags: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.created)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.quote)
      ..writeByte(3)
      ..write(obj.reference)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.commentary)
      ..writeByte(6)
      ..write(obj.tags.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'JournalEntry',
      json,
      ($checkedConvert) {
        final val = JournalEntry(
          created: $checkedConvert(
              'created', (v) => v == null ? null : DateTime.parse(v as String)),
          category: $checkedConvert('category', (v) => v as String? ?? 'other'),
          quote: $checkedConvert('quote', (v) => v as String? ?? ''),
          reference: $checkedConvert('reference', (v) => v as String? ?? ''),
          url: $checkedConvert('url', (v) => v as String? ?? ''),
          commentary: $checkedConvert('commentary', (v) => v as String? ?? ''),
          tags: $checkedConvert(
              'tags',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String) ?? const []),
        );
        return val;
      },
    );

Map<String, dynamic> _$JournalEntryToJson(JournalEntry instance) =>
    <String, dynamic>{
      'created': instance.created.toIso8601String(),
      'category': instance.category,
      'quote': instance.quote,
      'reference': instance.reference,
      'url': instance.url,
      'commentary': instance.commentary,
      'tags': instance.tags.toList(),
    };
