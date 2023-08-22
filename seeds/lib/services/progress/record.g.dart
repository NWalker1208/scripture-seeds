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
    )
      .._lastUpdate = fields[1] as DateTime
      .._lastProgress = fields[2] as int
      .._rewardAvailable = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, ProgressRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj._lastUpdate)
      ..writeByte(2)
      ..write(obj._lastProgress)
      ..writeByte(3)
      ..write(obj._rewardAvailable);
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
