// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChurchEventAdapter extends TypeAdapter<ChurchEvent> {
  @override
  final int typeId = 110;

  @override
  ChurchEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChurchEvent(
      id: fields[0] as String,
      title: fields[1] as String,
      start: fields[2] as DateTime,
      end: fields[3] as DateTime,
      level: fields[4] as EntityLevel,
      description: fields[7] as String,
      commissionId: fields[5] as String?,
      isBlocking: fields[6] as bool,
      dataAttachment: fields[8] as Attachment?,
    );
  }

  @override
  void write(BinaryWriter writer, ChurchEvent obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.start)
      ..writeByte(3)
      ..write(obj.end)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.commissionId)
      ..writeByte(6)
      ..write(obj.isBlocking)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.dataAttachment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChurchEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
