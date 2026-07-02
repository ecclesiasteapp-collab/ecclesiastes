// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommissionAdapter extends TypeAdapter<Commission> {
  @override
  final int typeId = 106;

  @override
  Commission read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Commission(
      id: fields[0] as String,
      type: fields[1] as CommissionType,
      entiteId: fields[2] as String,
      description: fields[3] as String?,
      responsableId: fields[4] as String?,
      responsableNom: fields[5] as String?,
      adjointId: fields[6] as String?,
      adjointNom: fields[7] as String?,
      sousCommissions: (fields[8] as List?)?.cast<SousCommission>(),
      membreIds: (fields[9] as List).cast<String>(),
      programmes: (fields[10] as List).cast<Programme>(),
      manuelsFormateur: (fields[11] as List).cast<LibraryDocument>(),
      manuelsApprenant: (fields[12] as List).cast<LibraryDocument>(),
      createdAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Commission obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.entiteId)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.responsableId)
      ..writeByte(5)
      ..write(obj.responsableNom)
      ..writeByte(6)
      ..write(obj.adjointId)
      ..writeByte(7)
      ..write(obj.adjointNom)
      ..writeByte(8)
      ..write(obj.sousCommissions)
      ..writeByte(9)
      ..write(obj.membreIds)
      ..writeByte(10)
      ..write(obj.programmes)
      ..writeByte(11)
      ..write(obj.manuelsFormateur)
      ..writeByte(12)
      ..write(obj.manuelsApprenant)
      ..writeByte(13)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommissionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SousCommissionAdapter extends TypeAdapter<SousCommission> {
  @override
  final int typeId = 107;

  @override
  SousCommission read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SousCommission(
      id: fields[0] as String,
      nom: fields[1] as String,
      responsableId: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SousCommission obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.responsableId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SousCommissionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
