// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_document_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LibraryDocumentModelAdapter extends TypeAdapter<LibraryDocumentModel> {
  @override
  final int typeId = 255;

  @override
  LibraryDocumentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LibraryDocumentModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      typeIndex: fields[3] as int,
      url: fields[4] as String,
      allowedRoles: (fields[5] as List).cast<String>(),
      minimumLevelIndex: fields[6] as int,
      tenantId: fields[7] as String?,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LibraryDocumentModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.typeIndex)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.allowedRoles)
      ..writeByte(6)
      ..write(obj.minimumLevelIndex)
      ..writeByte(7)
      ..write(obj.tenantId)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryDocumentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
