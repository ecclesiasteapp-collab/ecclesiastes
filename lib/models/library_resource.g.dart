// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_resource.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LibraryResourceAdapter extends TypeAdapter<LibraryResource> {
  @override
  final int typeId = 108;

  @override
  LibraryResource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LibraryResource(
      id: fields[0] as String,
      title: fields[1] as String,
      resourcePath: fields[2] as String,
      category: fields[3] as LibraryCategory,
      type: fields[4] as ResourceType,
      level: fields[5] as EntityLevel?,
      uploadDate: fields[6] as DateTime,
      description: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LibraryResource obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.resourcePath)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.level)
      ..writeByte(6)
      ..write(obj.uploadDate)
      ..writeByte(7)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryResourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LibraryCategoryAdapter extends TypeAdapter<LibraryCategory> {
  @override
  final int typeId = 113;

  @override
  LibraryCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LibraryCategory.cantiques;
      case 1:
        return LibraryCategory.catechisme;
      case 2:
        return LibraryCategory.liturgie;
      case 3:
        return LibraryCategory.penseeDirectrice;
      case 4:
        return LibraryCategory.programmes;
      case 5:
        return LibraryCategory.visionEglise;
      default:
        return LibraryCategory.cantiques;
    }
  }

  @override
  void write(BinaryWriter writer, LibraryCategory obj) {
    switch (obj) {
      case LibraryCategory.cantiques:
        writer.writeByte(0);
        break;
      case LibraryCategory.catechisme:
        writer.writeByte(1);
        break;
      case LibraryCategory.liturgie:
        writer.writeByte(2);
        break;
      case LibraryCategory.penseeDirectrice:
        writer.writeByte(3);
        break;
      case LibraryCategory.programmes:
        writer.writeByte(4);
        break;
      case LibraryCategory.visionEglise:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResourceTypeAdapter extends TypeAdapter<ResourceType> {
  @override
  final int typeId = 114;

  @override
  ResourceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ResourceType.pdf;
      case 1:
        return ResourceType.audio;
      case 2:
        return ResourceType.image;
      case 3:
        return ResourceType.text;
      default:
        return ResourceType.pdf;
    }
  }

  @override
  void write(BinaryWriter writer, ResourceType obj) {
    switch (obj) {
      case ResourceType.pdf:
        writer.writeByte(0);
        break;
      case ResourceType.audio:
        writer.writeByte(1);
        break;
      case ResourceType.image:
        writer.writeByte(2);
        break;
      case ResourceType.text:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
