// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ecclesiastical_entity_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EcclesiasticalEntityModelAdapter
    extends TypeAdapter<EcclesiasticalEntityModel> {
  @override
  final int typeId = 250;

  @override
  EcclesiasticalEntityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EcclesiasticalEntityModel(
      id: fields[0] as String,
      name: fields[1] as String,
      levelIndex: fields[2] as int,
      parentId: fields[3] as String?,
      metadata: (fields[4] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, EcclesiasticalEntityModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.levelIndex)
      ..writeByte(3)
      ..write(obj.parentId)
      ..writeByte(4)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EcclesiasticalEntityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
