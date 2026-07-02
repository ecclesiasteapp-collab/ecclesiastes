// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageEntityAdapter extends TypeAdapter<ImageEntity> {
  @override
  final int typeId = 112;

  @override
  ImageEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageEntity(
      id: fields[0] as String,
      title: fields[1] as String,
      imagePath: fields[2] as String,
      level: fields[3] as EntityLevel,
      responsibleName: fields[4] as String,
      uploadDate: fields[5] as DateTime,
      category: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ImageEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.responsibleName)
      ..writeByte(5)
      ..write(obj.uploadDate)
      ..writeByte(6)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
