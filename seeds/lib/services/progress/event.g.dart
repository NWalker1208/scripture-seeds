// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressEventAdapter extends TypeAdapter<ProgressEvent> {
  @override
  final int typeId = 2;

  @override
  ProgressEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressEvent(
      fields[1] as String,
      dateTime: fields[0] as DateTime,
      value: fields[2] as int,
      reset: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProgressEvent obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.topic)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.reset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressEvent _$ProgressEventFromJson(Map<String, dynamic> json) {
  return $checkedNew('ProgressEvent', json, () {
    final val = ProgressEvent(
      $checkedConvert(json, 'topic', (v) => v as String),
      dateTime: $checkedConvert(json, 'dateTime',
          (v) => v == null ? null : DateTime.parse(v as String)),
      value: $checkedConvert(json, 'value', (v) => v as int),
      reset: $checkedConvert(json, 'reset', (v) => v as bool),
    );
    return val;
  });
}

Map<String, dynamic> _$ProgressEventToJson(ProgressEvent instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime?.toIso8601String(),
      'topic': instance.topic,
      'value': instance.value,
      'reset': instance.reset,
    };
