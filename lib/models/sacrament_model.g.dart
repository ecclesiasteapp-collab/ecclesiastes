// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sacrament_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SacramentAdapter extends TypeAdapter<Sacrament> {
  @override
  final int typeId = 151;

  @override
  Sacrament read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sacrament(
      id: fields[0] as String,
      personId: fields[1] as String,
      type: fields[2] as String,
      date: fields[3] as DateTime,
      entityId: fields[4] as String,
      officiantName: fields[5] as String?,
      officiantId: fields[6] as String?,
      documentReference: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Sacrament obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.personId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.entityId)
      ..writeByte(5)
      ..write(obj.officiantName)
      ..writeByte(6)
      ..write(obj.officiantId)
      ..writeByte(7)
      ..write(obj.documentReference);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SacramentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
