// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HierarchyLevelConfigAdapter extends TypeAdapter<HierarchyLevelConfig> {
  @override
  final int typeId = 230;

  @override
  HierarchyLevelConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HierarchyLevelConfig(
      rank: fields[0] as int,
      id: fields[1] as String,
      label: fields[2] as String,
      officialResponsible: fields[3] as String,
      parentId: fields[4] as String?,
      canHaveAdjoint: fields[5] as bool,
      canHaveSuppleant: fields[6] as bool,
      permissions: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HierarchyLevelConfig obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.rank)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.label)
      ..writeByte(3)
      ..write(obj.officialResponsible)
      ..writeByte(4)
      ..write(obj.parentId)
      ..writeByte(5)
      ..write(obj.canHaveAdjoint)
      ..writeByte(6)
      ..write(obj.canHaveSuppleant)
      ..writeByte(7)
      ..write(obj.permissions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HierarchyLevelConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrganisationTypeConfigAdapter
    extends TypeAdapter<OrganisationTypeConfig> {
  @override
  final int typeId = 231;

  @override
  OrganisationTypeConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganisationTypeConfig(
      id: fields[0] as String,
      label: fields[1] as String,
      parentType: fields[2] as String?,
      standardBureau: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrganisationTypeConfig obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.parentType)
      ..writeByte(3)
      ..write(obj.standardBureau);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganisationTypeConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MinistryConfigAdapter extends TypeAdapter<MinistryConfig> {
  @override
  final int typeId = 232;

  @override
  MinistryConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MinistryConfig(
      id: fields[0] as String,
      label: fields[1] as String,
      rankOrder: fields[2] as int,
      isApostolic: fields[3] as bool,
      isSacerdoce: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MinistryConfig obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.rankOrder)
      ..writeByte(3)
      ..write(obj.isApostolic)
      ..writeByte(4)
      ..write(obj.isSacerdoce);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinistryConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
