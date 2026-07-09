// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mandate_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MandateModelAdapter extends TypeAdapter<MandateModel> {
  @override
  final int typeId = 252;

  @override
  MandateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MandateModel(
      id: fields[0] as String,
      personId: fields[1] as String,
      entityId: fields[2] as String,
      typeIndex: fields[3] as int,
      roleName: fields[4] as String,
      startDate: fields[5] as DateTime,
      endDate: fields[6] as DateTime?,
      isActive: fields[7] as bool,
      appointeeById: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MandateModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.personId)
      ..writeByte(2)
      ..write(obj.entityId)
      ..writeByte(3)
      ..write(obj.typeIndex)
      ..writeByte(4)
      ..write(obj.roleName)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.appointeeById);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MandateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
