// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntityModelAdapter extends TypeAdapter<EntityModel> {
  @override
  final int typeId = 233;

  @override
  EntityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EntityModel(
      id: fields[0] as String,
      nom: fields[1] as String,
      code: fields[2] as String,
      niveau: fields[3] as EntityLevel,
      entiteParentId: fields[4] as String?,
      responsableId: fields[5] as String?,
      responsableNom: fields[6] as String?,
      responsableRank: fields[7] as UserRole?,
      suppleantId: fields[8] as String?,
      suppleantNom: fields[9] as String?,
      commissions: (fields[10] as List).cast<Commission>(),
      nombreMembres: fields[11] as int,
      nombreMinistres: fields[12] as int,
      programmes: (fields[13] as List).cast<Programme>(),
      createdAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, EntityModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.niveau)
      ..writeByte(4)
      ..write(obj.entiteParentId)
      ..writeByte(5)
      ..write(obj.responsableId)
      ..writeByte(6)
      ..write(obj.responsableNom)
      ..writeByte(7)
      ..write(obj.responsableRank)
      ..writeByte(8)
      ..write(obj.suppleantId)
      ..writeByte(9)
      ..write(obj.suppleantNom)
      ..writeByte(10)
      ..write(obj.commissions)
      ..writeByte(11)
      ..write(obj.nombreMembres)
      ..writeByte(12)
      ..write(obj.nombreMinistres)
      ..writeByte(13)
      ..write(obj.programmes)
      ..writeByte(14)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
