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
        return EntityLevel.territoriale;
      case 4:
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
      case EntityLevel.territoriale:
        writer.writeByte(3);
        break;
      case EntityLevel.internationale:
        writer.writeByte(4);
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
        return UserRole.presidentTerritoriale;
      case 2:
        return UserRole.apotreChamp;
      case 3:
        return UserRole.apotreDistrict;
      case 4:
        return UserRole.chefCommunaute;
      case 5:
        return UserRole.ministre;
      case 6:
        return UserRole.respCommission;
      case 7:
        return UserRole.membre;
      case 8:
        return UserRole.superAdmin;
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
      case UserRole.presidentTerritoriale:
        writer.writeByte(1);
        break;
      case UserRole.apotreChamp:
        writer.writeByte(2);
        break;
      case UserRole.apotreDistrict:
        writer.writeByte(3);
        break;
      case UserRole.chefCommunaute:
        writer.writeByte(4);
        break;
      case UserRole.ministre:
        writer.writeByte(5);
        break;
      case UserRole.respCommission:
        writer.writeByte(6);
        break;
      case UserRole.membre:
        writer.writeByte(7);
        break;
      case UserRole.superAdmin:
        writer.writeByte(8);
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

class CommissionTypeAdapter extends TypeAdapter<CommissionType> {
  @override
  final int typeId = 22;

  @override
  CommissionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CommissionType.ecodim;
      case 1:
        return CommissionType.confirmation;
      case 2:
        return CommissionType.jeunesse;
      case 3:
        return CommissionType.econfi;
      case 4:
        return CommissionType.musique;
      case 5:
        return CommissionType.medicale;
      case 6:
        return CommissionType.aines;
      case 7:
        return CommissionType.construction;
      case 8:
        return CommissionType.securite;
      case 9:
        return CommissionType.presse;
      case 10:
        return CommissionType.papas;
      case 11:
        return CommissionType.mamans;
      case 12:
        return CommissionType.arimathee;
      case 13:
        return CommissionType.sacristie;
      case 14:
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
      case CommissionType.confirmation:
        writer.writeByte(1);
        break;
      case CommissionType.jeunesse:
        writer.writeByte(2);
        break;
      case CommissionType.econfi:
        writer.writeByte(3);
        break;
      case CommissionType.musique:
        writer.writeByte(4);
        break;
      case CommissionType.medicale:
        writer.writeByte(5);
        break;
      case CommissionType.aines:
        writer.writeByte(6);
        break;
      case CommissionType.construction:
        writer.writeByte(7);
        break;
      case CommissionType.securite:
        writer.writeByte(8);
        break;
      case CommissionType.presse:
        writer.writeByte(9);
        break;
      case CommissionType.papas:
        writer.writeByte(10);
        break;
      case CommissionType.mamans:
        writer.writeByte(11);
        break;
      case CommissionType.arimathee:
        writer.writeByte(12);
        break;
      case CommissionType.sacristie:
        writer.writeByte(13);
        break;
      case CommissionType.none:
        writer.writeByte(14);
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
