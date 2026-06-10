// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'territory_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TerritoryConfigAdapter extends TypeAdapter<TerritoryConfig> {
  @override
  final int typeId = 61;

  @override
  TerritoryConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TerritoryConfig(
      id: fields[0] as String,
      officialName: fields[1] as String,
      shortName: fields[2] as String,
      logoAssetPath: fields[3] as String,
      defaultCurrency: fields[4] as String,
      primaryLanguage: fields[5] as String,
      labelLevel5: fields[6] as String,
      labelLevel4: fields[7] as String,
      labelLevel3: fields[8] as String,
      labelLevel2: fields[9] as String,
      labelLevel1: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TerritoryConfig obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.officialName)
      ..writeByte(2)
      ..write(obj.shortName)
      ..writeByte(3)
      ..write(obj.logoAssetPath)
      ..writeByte(4)
      ..write(obj.defaultCurrency)
      ..writeByte(5)
      ..write(obj.primaryLanguage)
      ..writeByte(6)
      ..write(obj.labelLevel5)
      ..writeByte(7)
      ..write(obj.labelLevel4)
      ..writeByte(8)
      ..write(obj.labelLevel3)
      ..writeByte(9)
      ..write(obj.labelLevel2)
      ..writeByte(10)
      ..write(obj.labelLevel1);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TerritoryConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
