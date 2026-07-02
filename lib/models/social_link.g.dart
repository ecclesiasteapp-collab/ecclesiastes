// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_link.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SocialLinkAdapter extends TypeAdapter<SocialLink> {
  @override
  final int typeId = 119;

  @override
  SocialLink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SocialLink(
      id: fields[0] as String,
      entityName: fields[1] as String,
      platform: fields[2] as String,
      url: fields[3] as String,
      level: fields[4] as EntityLevel,
      isOfficial: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SocialLink obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.entityName)
      ..writeByte(2)
      ..write(obj.platform)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.isOfficial);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocialLinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
