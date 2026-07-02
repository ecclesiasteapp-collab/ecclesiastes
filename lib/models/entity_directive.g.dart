// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_directive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntityDirectiveAdapter extends TypeAdapter<EntityDirective> {
  @override
  final int typeId = 118;

  @override
  EntityDirective read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EntityDirective(
      id: fields[0] as String,
      titre: fields[1] as String,
      contenu: fields[2] as String,
      type: fields[3] as DirectiveType,
      priorite: fields[4] as DirectivePriority,
      entiteId: fields[5] as String,
      entiteLevel: fields[6] as EntityLevel,
      auteurId: fields[7] as String,
      auteurNom: fields[8] as String,
      destinatairesMinistresIds: (fields[11] as List).cast<String>(),
      dateCreation: fields[9] as DateTime?,
      dateExpiration: fields[10] as DateTime?,
      isConfidential: fields[12] as bool,
      documentPath: fields[13] as String?,
      documentNom: fields[14] as String?,
      lectureStatus: (fields[15] as Map?)?.cast<String, DirectiveStatus>(),
      tagsCommissions: (fields[16] as List?)?.cast<String>(),
      lienExterne: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EntityDirective obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titre)
      ..writeByte(2)
      ..write(obj.contenu)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.priorite)
      ..writeByte(5)
      ..write(obj.entiteId)
      ..writeByte(6)
      ..write(obj.entiteLevel)
      ..writeByte(7)
      ..write(obj.auteurId)
      ..writeByte(8)
      ..write(obj.auteurNom)
      ..writeByte(9)
      ..write(obj.dateCreation)
      ..writeByte(10)
      ..write(obj.dateExpiration)
      ..writeByte(11)
      ..write(obj.destinatairesMinistresIds)
      ..writeByte(12)
      ..write(obj.isConfidential)
      ..writeByte(13)
      ..write(obj.documentPath)
      ..writeByte(14)
      ..write(obj.documentNom)
      ..writeByte(15)
      ..write(obj.lectureStatus)
      ..writeByte(16)
      ..write(obj.tagsCommissions)
      ..writeByte(17)
      ..write(obj.lienExterne);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityDirectiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DirectiveTypeAdapter extends TypeAdapter<DirectiveType> {
  @override
  final int typeId = 115;

  @override
  DirectiveType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DirectiveType.directive;
      case 1:
        return DirectiveType.message;
      case 2:
        return DirectiveType.annonce;
      case 3:
        return DirectiveType.alerte;
      case 4:
        return DirectiveType.formulaire;
      case 5:
        return DirectiveType.document;
      default:
        return DirectiveType.directive;
    }
  }

  @override
  void write(BinaryWriter writer, DirectiveType obj) {
    switch (obj) {
      case DirectiveType.directive:
        writer.writeByte(0);
        break;
      case DirectiveType.message:
        writer.writeByte(1);
        break;
      case DirectiveType.annonce:
        writer.writeByte(2);
        break;
      case DirectiveType.alerte:
        writer.writeByte(3);
        break;
      case DirectiveType.formulaire:
        writer.writeByte(4);
        break;
      case DirectiveType.document:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DirectiveTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DirectivePriorityAdapter extends TypeAdapter<DirectivePriority> {
  @override
  final int typeId = 116;

  @override
  DirectivePriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DirectivePriority.basse;
      case 1:
        return DirectivePriority.normale;
      case 2:
        return DirectivePriority.haute;
      case 3:
        return DirectivePriority.urgente;
      default:
        return DirectivePriority.basse;
    }
  }

  @override
  void write(BinaryWriter writer, DirectivePriority obj) {
    switch (obj) {
      case DirectivePriority.basse:
        writer.writeByte(0);
        break;
      case DirectivePriority.normale:
        writer.writeByte(1);
        break;
      case DirectivePriority.haute:
        writer.writeByte(2);
        break;
      case DirectivePriority.urgente:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DirectivePriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DirectiveStatusAdapter extends TypeAdapter<DirectiveStatus> {
  @override
  final int typeId = 117;

  @override
  DirectiveStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DirectiveStatus.nonLu;
      case 1:
        return DirectiveStatus.lu;
      case 2:
        return DirectiveStatus.enCours;
      case 3:
        return DirectiveStatus.complete;
      default:
        return DirectiveStatus.nonLu;
    }
  }

  @override
  void write(BinaryWriter writer, DirectiveStatus obj) {
    switch (obj) {
      case DirectiveStatus.nonLu:
        writer.writeByte(0);
        break;
      case DirectiveStatus.lu:
        writer.writeByte(1);
        break;
      case DirectiveStatus.enCours:
        writer.writeByte(2);
        break;
      case DirectiveStatus.complete:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DirectiveStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
