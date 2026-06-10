// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_document.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LibraryDocumentAdapter extends TypeAdapter<LibraryDocument> {
  @override
  final int typeId = 14;

  @override
  LibraryDocument read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LibraryDocument(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      type: fields[3] as DocumentType,
      filePath: fields[4] as String,
      fileSize: fields[5] as int,
      allowedCategories: (fields[7] as List).cast<UserCategory>(),
      allowedLevels: (fields[8] as List).cast<EntityLevel>(),
      allowedCommissions: (fields[9] as List).cast<CommissionType>(),
      uploadDate: fields[6] as DateTime?,
      author: fields[10] as String?,
      version: fields[11] as String?,
      isConfidential: fields[12] as bool,
      expiryDate: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LibraryDocument obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.filePath)
      ..writeByte(5)
      ..write(obj.fileSize)
      ..writeByte(6)
      ..write(obj.uploadDate)
      ..writeByte(7)
      ..write(obj.allowedCategories)
      ..writeByte(8)
      ..write(obj.allowedLevels)
      ..writeByte(9)
      ..write(obj.allowedCommissions)
      ..writeByte(10)
      ..write(obj.author)
      ..writeByte(11)
      ..write(obj.version)
      ..writeByte(12)
      ..write(obj.isConfidential)
      ..writeByte(13)
      ..write(obj.expiryDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryDocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserCategoryAdapter extends TypeAdapter<UserCategory> {
  @override
  final int typeId = 10;

  @override
  UserCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserCategory.membre;
      case 1:
        return UserCategory.ministre;
      case 2:
        return UserCategory.responsable;
      default:
        return UserCategory.membre;
    }
  }

  @override
  void write(BinaryWriter writer, UserCategory obj) {
    switch (obj) {
      case UserCategory.membre:
        writer.writeByte(0);
        break;
      case UserCategory.ministre:
        writer.writeByte(1);
        break;
      case UserCategory.responsable:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DocumentTypeAdapter extends TypeAdapter<DocumentType> {
  @override
  final int typeId = 13;

  @override
  DocumentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DocumentType.penseesDirectrices;
      case 1:
        return DocumentType.manuelCommission;
      case 2:
        return DocumentType.programmeApostolique;
      case 3:
        return DocumentType.programmeCommission;
      case 4:
        return DocumentType.directives;
      case 5:
        return DocumentType.cantiques;
      case 6:
        return DocumentType.formulaire;
      case 7:
        return DocumentType.liturgie;
      case 8:
        return DocumentType.formation;
      case 9:
        return DocumentType.autre;
      default:
        return DocumentType.penseesDirectrices;
    }
  }

  @override
  void write(BinaryWriter writer, DocumentType obj) {
    switch (obj) {
      case DocumentType.penseesDirectrices:
        writer.writeByte(0);
        break;
      case DocumentType.manuelCommission:
        writer.writeByte(1);
        break;
      case DocumentType.programmeApostolique:
        writer.writeByte(2);
        break;
      case DocumentType.programmeCommission:
        writer.writeByte(3);
        break;
      case DocumentType.directives:
        writer.writeByte(4);
        break;
      case DocumentType.cantiques:
        writer.writeByte(5);
        break;
      case DocumentType.formulaire:
        writer.writeByte(6);
        break;
      case DocumentType.liturgie:
        writer.writeByte(7);
        break;
      case DocumentType.formation:
        writer.writeByte(8);
        break;
      case DocumentType.autre:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
