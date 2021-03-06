// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressRecordAdapter extends TypeAdapter<ProgressRecord> {
  @override
  final int typeId = 0;

  @override
  ProgressRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressRecord(
      fields[0] as String,
      lastUpdate: fields[1] as DateTime,
      lastProgress: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProgressRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.topic)
      ..writeByte(1)
      ..write(obj.lastUpdate)
      ..writeByte(2)
      ..write(obj.lastProgress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressRecord _$ProgressRecordFromJson(Map<String, dynamic> json) {
  return $checkedNew('ProgressRecord', json, () {
    final val = ProgressRecord(
      $checkedConvert(json, 'topic', (v) => v as String),
      lastUpdate: $checkedConvert(json, 'lastUpdate',
          (v) => v == null ? null : DateTime.parse(v as String)),
      lastProgress: $checkedConvert(json, 'lastProgress', (v) => v as int),
    );
    return val;
  });
}

Map<String, dynamic> _$ProgressRecordToJson(ProgressRecord instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
      'lastProgress': instance.lastProgress,
    };
