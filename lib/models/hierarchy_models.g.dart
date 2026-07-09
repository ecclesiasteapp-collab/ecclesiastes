// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hierarchy_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntityLevelAdapter extends TypeAdapter<EntityLevel> {
  @override
  final int typeId = 20;

  @override
  EntityLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EntityLevel.communaute;
      case 1:
        return EntityLevel.district;
      case 2:
        return EntityLevel.champ;
      case 3:
        return EntityLevel.regionApostolique;
      case 4:
        return EntityLevel.territoriale;
      case 5:
        return EntityLevel.internationale;
      default:
        return EntityLevel.communaute;
    }
  }

  @override
  void write(BinaryWriter writer, EntityLevel obj) {
    switch (obj) {
      case EntityLevel.communaute:
        writer.writeByte(0);
        break;
      case EntityLevel.district:
        writer.writeByte(1);
        break;
      case EntityLevel.champ:
        writer.writeByte(2);
        break;
      case EntityLevel.regionApostolique:
        writer.writeByte(3);
        break;
      case EntityLevel.territoriale:
        writer.writeByte(4);
        break;
      case EntityLevel.internationale:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserRoleAdapter extends TypeAdapter<UserRole> {
  @override
  final int typeId = 21;

  @override
  UserRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserRole.apotrePatriarche;
      case 1:
        return UserRole.apotreDistrict;
      case 2:
        return UserRole.apotreResponsable;
      case 3:
        return UserRole.apotre;
      case 4:
        return UserRole.eveque;
      case 5:
        return UserRole.ancien;
      case 6:
        return UserRole.lead;
      case 7:
        return UserRole.berger;
      case 8:
        return UserRole.evangeliste;
      case 9:
        return UserRole.pretre;
      case 10:
        return UserRole.diacre;
      case 11:
        return UserRole.sousDiacre;
      case 12:
        return UserRole.frereCharge;
      case 13:
        return UserRole.conductrice;
      case 14:
        return UserRole.membre;
      case 15:
        return UserRole.superAdmin;
      case 16:
        return UserRole.respCommission;
      default:
        return UserRole.apotrePatriarche;
    }
  }

  @override
  void write(BinaryWriter writer, UserRole obj) {
    switch (obj) {
      case UserRole.apotrePatriarche:
        writer.writeByte(0);
        break;
      case UserRole.apotreDistrict:
        writer.writeByte(1);
        break;
      case UserRole.apotreResponsable:
        writer.writeByte(2);
        break;
      case UserRole.apotre:
        writer.writeByte(3);
        break;
      case UserRole.eveque:
        writer.writeByte(4);
        break;
      case UserRole.ancien:
        writer.writeByte(5);
        break;
      case UserRole.lead:
        writer.writeByte(6);
        break;
      case UserRole.berger:
        writer.writeByte(7);
        break;
      case UserRole.evangeliste:
        writer.writeByte(8);
        break;
      case UserRole.pretre:
        writer.writeByte(9);
        break;
      case UserRole.diacre:
        writer.writeByte(10);
        break;
      case UserRole.sousDiacre:
        writer.writeByte(11);
        break;
      case UserRole.frereCharge:
        writer.writeByte(12);
        break;
      case UserRole.conductrice:
        writer.writeByte(13);
        break;
      case UserRole.membre:
        writer.writeByte(14);
        break;
      case UserRole.superAdmin:
        writer.writeByte(15);
        break;
      case UserRole.respCommission:
        writer.writeByte(16);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommissionRoleAdapter extends TypeAdapter<CommissionRole> {
  @override
  final int typeId = 23;

  @override
  CommissionRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CommissionRole.responsable;
      case 1:
        return CommissionRole.adjoint;
      case 2:
        return CommissionRole.membre;
      default:
        return CommissionRole.responsable;
    }
  }

  @override
  void write(BinaryWriter writer, CommissionRole obj) {
    switch (obj) {
      case CommissionRole.responsable:
        writer.writeByte(0);
        break;
      case CommissionRole.adjoint:
        writer.writeByte(1);
        break;
      case CommissionRole.membre:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommissionRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfilDocumentaireAdapter extends TypeAdapter<ProfilDocumentaire> {
  @override
  final int typeId = 24;

  @override
  ProfilDocumentaire read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProfilDocumentaire.ministre;
      case 1:
        return ProfilDocumentaire.formateur;
      case 2:
        return ProfilDocumentaire.membre;
      default:
        return ProfilDocumentaire.ministre;
    }
  }

  @override
  void write(BinaryWriter writer, ProfilDocumentaire obj) {
    switch (obj) {
      case ProfilDocumentaire.ministre:
        writer.writeByte(0);
        break;
      case ProfilDocumentaire.formateur:
        writer.writeByte(1);
        break;
      case ProfilDocumentaire.membre:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfilDocumentaireAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommissionTypeAdapter extends TypeAdapter<CommissionType> {
  @override
  final int typeId = 22;

  @override
  CommissionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CommissionType.ecodim;
      case 1:
        return CommissionType.econfi;
      case 2:
        return CommissionType.jeunesse;
      case 3:
        return CommissionType.papas;
      case 4:
        return CommissionType.mamans;
      case 5:
        return CommissionType.aines;
      case 6:
        return CommissionType.musique;
      case 7:
        return CommissionType.presseMediasSonorisation;
      case 8:
        return CommissionType.josephArimathee;
      case 9:
        return CommissionType.securiteProtocole;
      case 10:
        return CommissionType.medicale;
      case 11:
        return CommissionType.construction;
      case 12:
        return CommissionType.sacristie;
      case 13:
        return CommissionType.none;
      default:
        return CommissionType.ecodim;
    }
  }

  @override
  void write(BinaryWriter writer, CommissionType obj) {
    switch (obj) {
      case CommissionType.ecodim:
        writer.writeByte(0);
        break;
      case CommissionType.econfi:
        writer.writeByte(1);
        break;
      case CommissionType.jeunesse:
        writer.writeByte(2);
        break;
      case CommissionType.papas:
        writer.writeByte(3);
        break;
      case CommissionType.mamans:
        writer.writeByte(4);
        break;
      case CommissionType.aines:
        writer.writeByte(5);
        break;
      case CommissionType.musique:
        writer.writeByte(6);
        break;
      case CommissionType.presseMediasSonorisation:
        writer.writeByte(7);
        break;
      case CommissionType.josephArimathee:
        writer.writeByte(8);
        break;
      case CommissionType.securiteProtocole:
        writer.writeByte(9);
        break;
      case CommissionType.medicale:
        writer.writeByte(10);
        break;
      case CommissionType.construction:
        writer.writeByte(11);
        break;
      case CommissionType.sacristie:
        writer.writeByte(12);
        break;
      case CommissionType.none:
        writer.writeByte(13);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommissionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProgrammeTypeAdapter extends TypeAdapter<ProgrammeType> {
  @override
  final int typeId = 25;

  @override
  ProgrammeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProgrammeType.mensuel;
      case 1:
        return ProgrammeType.trimestriel;
      case 2:
        return ProgrammeType.annuel;
      case 3:
        return ProgrammeType.special;
      default:
        return ProgrammeType.mensuel;
    }
  }

  @override
  void write(BinaryWriter writer, ProgrammeType obj) {
    switch (obj) {
      case ProgrammeType.mensuel:
        writer.writeByte(0);
        break;
      case ProgrammeType.trimestriel:
        writer.writeByte(1);
        break;
      case ProgrammeType.annuel:
        writer.writeByte(2);
        break;
      case ProgrammeType.special:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgrammeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatutProgrammeAdapter extends TypeAdapter<StatutProgramme> {
  @override
  final int typeId = 26;

  @override
  StatutProgramme read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StatutProgramme.brouillon;
      case 1:
        return StatutProgramme.valide;
      case 2:
        return StatutProgramme.publie;
      case 3:
        return StatutProgramme.archive;
      default:
        return StatutProgramme.brouillon;
    }
  }

  @override
  void write(BinaryWriter writer, StatutProgramme obj) {
    switch (obj) {
      case StatutProgramme.brouillon:
        writer.writeByte(0);
        break;
      case StatutProgramme.valide:
        writer.writeByte(1);
        break;
      case StatutProgramme.publie:
        writer.writeByte(2);
        break;
      case StatutProgramme.archive:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatutProgrammeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DocumentCategorieAdapter extends TypeAdapter<DocumentCategorie> {
  @override
  final int typeId = 27;

  @override
  DocumentCategorie read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DocumentCategorie.manuel_ministre;
      case 1:
        return DocumentCategorie.manuel_formateur;
      case 2:
        return DocumentCategorie.manuel_apprenant;
      case 3:
        return DocumentCategorie.pensee_directrice;
      case 4:
        return DocumentCategorie.catechisme;
      case 5:
        return DocumentCategorie.cantique;
      case 6:
        return DocumentCategorie.liturgie;
      case 7:
        return DocumentCategorie.rapport_template;
      default:
        return DocumentCategorie.manuel_ministre;
    }
  }

  @override
  void write(BinaryWriter writer, DocumentCategorie obj) {
    switch (obj) {
      case DocumentCategorie.manuel_ministre:
        writer.writeByte(0);
        break;
      case DocumentCategorie.manuel_formateur:
        writer.writeByte(1);
        break;
      case DocumentCategorie.manuel_apprenant:
        writer.writeByte(2);
        break;
      case DocumentCategorie.pensee_directrice:
        writer.writeByte(3);
        break;
      case DocumentCategorie.catechisme:
        writer.writeByte(4);
        break;
      case DocumentCategorie.cantique:
        writer.writeByte(5);
        break;
      case DocumentCategorie.liturgie:
        writer.writeByte(6);
        break;
      case DocumentCategorie.rapport_template:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentCategorieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EntityResponsibleRoleAdapter extends TypeAdapter<EntityResponsibleRole> {
  @override
  final int typeId = 28;

  @override
  EntityResponsibleRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EntityResponsibleRole.responsable;
      case 1:
        return EntityResponsibleRole.suppleant;
      default:
        return EntityResponsibleRole.responsable;
    }
  }

  @override
  void write(BinaryWriter writer, EntityResponsibleRole obj) {
    switch (obj) {
      case EntityResponsibleRole.responsable:
        writer.writeByte(0);
        break;
      case EntityResponsibleRole.suppleant:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityResponsibleRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
