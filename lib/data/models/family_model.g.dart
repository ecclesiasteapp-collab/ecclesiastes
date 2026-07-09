// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FamilyModelAdapter extends TypeAdapter<FamilyModel> {
  @override
  final int typeId = 257;

  @override
  FamilyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FamilyModel(
      id: fields[0] as String,
      name: fields[1] as String,
      entityId: fields[2] as String,
      headOfFamilyId: fields[3] as String,
      address: fields[4] as String,
      memberIds: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FamilyModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.entityId)
      ..writeByte(3)
      ..write(obj.headOfFamilyId)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.memberIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
