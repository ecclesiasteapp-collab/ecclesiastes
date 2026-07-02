// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_responsible.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntityResponsibleAdapter extends TypeAdapter<EntityResponsible> {
  @override
  final int typeId = 107;

  @override
  EntityResponsible read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EntityResponsible(
      id: fields[0] as String,
      entityId: fields[1] as String,
      entityName: fields[2] as String,
      level: fields[3] as String,
      principalName: fields[4] as String,
      principalEmail: fields[5] as String?,
      deputyName: fields[6] as String?,
      deputyEmail: fields[7] as String?,
      startDate: fields[8] as DateTime,
      endDate: fields[9] as DateTime?,
      isActive: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, EntityResponsible obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.entityId)
      ..writeByte(2)
      ..write(obj.entityName)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.principalName)
      ..writeByte(5)
      ..write(obj.principalEmail)
      ..writeByte(6)
      ..write(obj.deputyName)
      ..writeByte(7)
      ..write(obj.deputyEmail)
      ..writeByte(8)
      ..write(obj.startDate)
      ..writeByte(9)
      ..write(obj.endDate)
      ..writeByte(10)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityResponsibleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
